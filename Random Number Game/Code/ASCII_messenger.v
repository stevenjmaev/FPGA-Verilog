`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2021 12:45:55 PM
// Design Name: 
// Module Name: ASCII_messenger
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ASCII_messenger(
    input clk, reset_n,
    input [3:0] msg_index,
    input start,
    input rx,
    output tx,
    output done
    );
    
    wire resetCounter, wr_en, count_en;
    wire [7:0] ROM_ADDR, ROM_2_UART;
    wire [3:0] count;
    
ASCI_messenger_fsm FSM(
    .clk(clk), .reset_n(reset_n),
    .start(start), 
    .count(count),
    .resetCounter(resetCounter), .wr_en(wr_en), .count_en(count_en)
    );
    
    assign ROM_ADDR = {msg_index, count};
    
synch_rom ROM(
    .clk(clk),
    .addr(ROM_ADDR),
    .data(ROM_2_UART)
    );
        
udl_counter #(.BITS(4)) characterCounter(
    .clk(clk),
    .reset_n(reset_n & (~resetCounter)),
    .enable(count_en),
    .up(1), //when asserted the counter is up counter; otherwise, it is a down counter
    .load(0),
    .D(0),
    .Q(count)
    );  
    
uart #(.DBIT(8), .SB_TICK(16)) myUART (
    .clk(clk),            // input wire clk
    .reset_n(reset_n),    // input wire reset
    
    // receiver port
    .r_data(),            //No Connect
    .rd_uart(0),          //Set to Zero
    .rx_empty(UART_empty),     //No Connect or will this be the "empty" output wire
    .rx(rx),
    
    // transmitter port
    .w_data(ROM_2_UART),
    .wr_uart(wr_en), // i.e. if memory is zero, it is the end of the message
    .tx_full(),           //No Connect?
    .tx(tx),
    
    // baud rate generator
    .TIMER_FINAL_VALUE(11'd650)   // Baud Rate = 9600 bps
    );    
    
endmodule
