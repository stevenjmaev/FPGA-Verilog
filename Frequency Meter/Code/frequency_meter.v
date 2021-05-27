`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2021 04:34:08 PM
// Design Name: 
// Module Name: frequency_meter
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


module frequency_meter(
    input clk, reset_n,
    input waveform,
    output [6:0] sseg,
    output [7:0] AN_index,
    output dp
    );
    
    wire [25:0] data_r, bin;
    wire [26+(26-4)/3:0] bcd;
    wire [1:0] addr_r;
    
    freq_memory MEMORY(
        .clk(clk), .reset_n(reset_n),
        .waveform(waveform),
        .addr_r(addr_r),
        .data_r(data_r)
    );  
    
    average_4vals AVGERAGER(
        .clk(clk), .reset_n(reset_n),
        .addr_r(addr_r),                // output which data location you want from the memory (it increments (00,01,10,11))
        .data_r(data_r),                // input the data from the MEMORY
        .average(bin)
    );  
        
    bin2bcd #(.W(26)) BCD_CONVERTER(
        .bin(bin),     // binary
        .bcd(bcd)      // bcd  
    );
    
    // input format: {enable,bcd,dp}
    sseg_driver DRIVER(
        .I0({1'b1,bcd[31:28],1'b0}), 
        .I1({1'b1,bcd[27:24],1'b0}), 
        .I2({1'b1,bcd[23:20],1'b0}), 
        .I3({1'b1,bcd[19:16],1'b0}), 
        .I4({1'b1,bcd[15:12],1'b0}), 
        .I5({1'b1,bcd[11:8],1'b0}), 
        .I6({1'b1,bcd[7:4],1'b0}), 
        .I7({1'b1,bcd[3:0],1'b0}),
        .clk(clk), .reset_n(reset_n),
        .AN(AN_index),
        .sseg(sseg),
        .DP(dp)
    );
    
endmodule
