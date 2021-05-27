`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 05:12:20 PM
// Design Name: 
// Module Name: freq_memory
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


module freq_memory(
    input clk, reset_n,
    input waveform,
    input [1:0] addr_r,
    output [$clog2(50_000_000)-1:0] data_r
    );
    wire [$clog2(50_000_000)-1:0] frequency;
    wire writeEnable;
    reg [1:0] addr_w;
    
    // increment the addr_w every time there is a new measurement
    always @(posedge clk)
    begin
        if (~reset_n)
            addr_w <= 2'b00;
        else if(writeEnable)
            addr_w <= addr_w + 1; 
    end
    
    freq_measurement MEASURE(
        .waveform(waveform),
        .clk(clk),
        .reset_n(reset_n),
        .done(writeEnable),        // active when the measurement is done
        .frequency(frequency)
    );
    
    reg_file #(.ADDR_WIDTH(2), .DATA_WIDTH($clog2(50_000_000))) DATA_BANK(
        .clk(clk),
        .we(writeEnable),
        .address_w(addr_w), 
        .address_r(addr_r),
        .data_w(frequency),
        .data_r(data_r)    
    );
    
endmodule
