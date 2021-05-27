`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 04:51:35 PM
// Design Name: 
// Module Name: morse_decoder
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


module morse_decoder #(FINAL_VALUE = 5_000_000) (
        input b,
        input clk,
        input reset_n,
        output dot,
        output dash,
        output LG,
        output WG    
    );

    wire [4:0] counterValue;
    wire count_reset;

    timer_counter #(.BITS(5), .FINAL_VALUE(FINAL_VALUE)) counter_for_FSM(
        .clk(clk),
        //.reset_n(reset_n),
        .reset_n({reset_n & ~count_reset}),
        .Q(counterValue)
    );

    morse_decoder_fsm_revised #(.BITS(5)) morse_FSM(
        .b(b),
        .clk(clk),
        .reset_n(reset_n),
        .count(counterValue),
        .dot(dot),
        .dash(dash),
        .LG(LG),
        .WG(WG),
        .count_reset(count_reset)
    );    
    
    
    
    
endmodule
