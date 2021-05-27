`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 07:01:35 PM
// Design Name: 
// Module Name: morse_decoder_application
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


module morse_decoder_application #(parameter FINAL_VALUE = 5_000_000, N = 5) (

    //Inputs
    input clk,      //synchronous clock input
    input b_in,     //Input for morse code
    input read_in,  //Input for read button of the FIFO
    input reset_n,  //Resets the circuit
    input rx,       //Input for the read terminal 
    
    //Outputs
    output [7:0] AN_index,  //Index of AN Values  
    output [6:0] sseg,      //Seven Segment diisplay value
    output DP,              //Controls Seven segment decimal point
    output empty,           //Controls LED to let user know if FIFO is empty
    output tx               //Output of the transmitter port
    );

//***************** Wire Definitions***************************************************************
    wire [11:0] UDL_bcd;      
    wire [N-1:0] shift_reg_out;
    wire [1:0] shift;
    wire WG_Delayed, read, b, full;
    wire [2:0] Q;
    wire [7:0] ROM_ADDRESS, ROM_2_UART, FIFO_out;
    
    assign shift = {(dot^dash), 1'b0};  //Reduction Operator for XOR
//    assign rx = 1'b1;                   //Need to assign rx to 'high', do assignmnet here
    
//***************** Button Inputs *****************************************************************
    button b_input_debounced(
        .clk(clk), 
        .reset_n(reset_n),
        .noisy(b_in),
        .debounced(b),
        .p_edge(), .n_edge(), ._edge()
    );
    
    button read_input_debounced(
        .clk(clk), 
        .reset_n(reset_n),
        .noisy(read_in),
        .debounced(),
        .p_edge(read), .n_edge(), ._edge()
    );         

//***************** Morse Decoder Function Call ***************************************************
    morse_decoder #(.FINAL_VALUE(FINAL_VALUE)) myMorseDecoder(
        .b(b),
        .clk(clk),
        .reset_n(reset_n),
        .dot(dot),
        .dash(dash),
        .LG(LG),
        .WG(WG)    
    );  
    
    D_FF myD_FF(
        .clk(clk),
        .D(WG),
        .reset_n(reset_n),
        .Q(WG_Delayed)
    );
   
    Shift_Register #(.N(5)) Five_bit_shift_reg (
        .clk(clk),                      //Synchronous PC Clock 
        .reset_n(reset_n & ~(LG|WG) ),  //Resets Circuit when user pushed button, OR there is a LG/WG Thrown
        .MSB_in(0),                     //Most Significant bit of input Data
        .LSB_in(dash),                  //Least Significant Bit of input Data, This will shift in when "shift"  = = 1.
        .I(0),                          //Value you want to load into the register for a parallel load
        .s(shift),                      //Control Signal: Determines if register does a No Change(00), shift-right(01), shift-left(10), or Parallel Load(11)
        .Q(shift_reg_out)               //This is the output of the Register - Need To direct to the SSEG
    );
    
    udl_counter #(.BITS(3)) Three_Bit_UDL_Counter(
        .clk(clk),
        .reset_n(reset_n & ~(LG|WG)),   //Resets circuitwhen user pushed button, OR there is a LG/WG Thrown
        .enable(dot^dash),
        .load(Q == 'd5),                //Needs to be a logic 1, when the shift register shifts five bits
        .up(1),
        .D(0),
        .Q(Q)                           //This is the output of the counter - Need To direct to the SSEG
    );
    
    mux_2x1_nbit #(.n(8)) myMUX(
        .x0({Q, shift_reg_out}), .x1(8'b1110_0000),
        .select(WG),
        .y(ROM_ADDRESS)
    );    

//***************** Synchronous ROM ********************************************************
    synch_rom ROM(
        .clk(clk),
        .addr(ROM_ADDRESS),
        .data(ROM_2_UART)
    );
    
//   fifo_generator_0 FIFO (
//        .clk(clk),            // input wire clk
//        .srst(~reset_n),      // input wire reset
//        .din(ROM_2_FIFO),      // input wire [7 : 0] din
//        .wr_en(~full & (LG | WG | WG_Delayed)),  // input wire wr_en
//        .rd_en(read),  // input wire rd_en
//        .dout(FIFO_out),    // output wire [7 : 0] dout
//        .full(full),    // output wire full
//        .empty(empty)  // output wire empty
//    );

    uart #(.DBIT(8), .SB_TICK(16)) myUART (
      .clk(clk),            // input wire clk
      .reset_n(reset_n),    // input wire reset
      
      // receiver port
      .r_data(),            //No Connect
      .rd_uart(0),          //Set to Zero
      .rx_empty(empty),     //No Connect or will this be the "empty" output wire
      .rx(rx),              //Assigned to 1'b1 earlier in wire definition section. Assigned as wire to reduce probability of error
      
      // transmitter port
      .w_data(ROM_2_UART),
      .wr_uart(~full & (LG | WG | WG_Delayed)),
      .tx_full(),           //No Connect?
      .tx(tx),
        
      // baud rate generator
      .TIMER_FINAL_VALUE(11'd650)   // Baud Rate = 9600 bps
    );
   
//**************OUTPUT SECTION**************************************************************
    sseg_driver mySSEG( //Format for inputs: {enable,[4bitNumber],decimalPoint}
        .I0({~empty, ROM_2_UART[7:4], 1'b0}),                   .I1({~empty, ROM_2_UART[3:0], 1'b0}),                   //These will be the UART Output 
        .I2(0),                                                 .I3({(Q == 3'd5), {3'b000,shift_reg_out[4]}, 1'b0}),    //These represent output for the Shift Register
        .I4({(Q >= 3'd4), {3'b000,shift_reg_out[3]}, 1'b0}),    .I5({(Q >= 3'd3), {3'b000,shift_reg_out[2]}, 1'b0}),    //These represent output for SR
        .I6({(Q >= 3'd2), {3'b000,shift_reg_out[1]}, 1'b0}),    .I7({(Q >= 3'd1), {3'b000,shift_reg_out[0]}, 1'b0}),    //These represent output for SR
        .clk(clk),
        .reset_n(reset_n),
        
        //SSEG Outputs
        .AN(AN_index),
        .sseg(sseg),
        .DP(DP)
    );    
    
endmodule
