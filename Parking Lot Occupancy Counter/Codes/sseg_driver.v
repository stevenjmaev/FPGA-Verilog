`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2021 01:33:04 PM
// Design Name: 
// Module Name: sseg_driver
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


module sseg_driver(
    input [5:0] I0, I1, I2, I3, I4, I5, I6, I7,
    input clk, reset_n,
    output [7:0] AN,
    output [6:0] sseg,
    output DP
    );
    
    wire [5:0] D_out;           //output of the 
    wire [7:0] AN_oneHot;		//Hold output of decoder (it will output a '1' for the desired sseg module)
    wire [2:0] count;
    wire doneToenable;
    
    assign DP = ~D_out[0];      //Invert to account for common anode
    assign AN = ~AN_oneHot; 	//Convert from one hot to zero hot selection (so it outputs a '0'
//								//for desired sseg module)
    
    timer_parameter #(.FINAL_VALUE(187_500)) timer( // (1.875 ms timer => 533 Hz frequency)
        .clk(clk),          
        .reset_n(reset_n),  
        .enable(1),         
        .done(doneToenable) 
    );	
    
    //This is our counter which will give us counts from 0 to 7 (000 to 111)
    udl_counter #(.BITS(3)) counter(
        .clk(clk),                  //clock signal
        .reset_n(reset_n),          //reset signal from input connection (used for simulation purposes mainly)
        .enable(doneToenable),      //Wire connecting the timer to the Counter 
        .up(1),                     //Count up
        .load(0),                   //we aren't loading anything
        .D(0),                      //we aren't loading anything
        .Q(count)                   //The output from the counter 
    );
    
    mux_8x1_nbit #(.n(6)) mux(
        .x0(I0), 
        .x1(I1),
        .x2(I2),
        .x3(I3),
        .x4(I4),
        .x5(I5),
        .x6(I6),
        .x7(I7),
        .select(count),
        .y(D_out)
        );
    
    decoder_generic #(.N(3)) decode_AN 
    (
        .w(count),   	        //input
        .en(D_out[5]),          //enable pin
        .y(AN_oneHot)           //output (which sseg to activate)
    );
    
    hex2sseg code_converter 
    (
        .hex(D_out[4:1]),       //input hex
        .sseg(sseg)             //output sseg (Common anode)
    );
    
endmodule
