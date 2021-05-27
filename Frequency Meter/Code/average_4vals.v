`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2021 02:31:50 PM
// Design Name: 
// Module Name: average_4vals
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


module average_4vals(
    input clk, reset_n,
    input [25:0] data_r,
    output reg [1:0] addr_r,
    output reg [25:0] average
    );
    
    wire [25:0] sum;
    wire resetAdder, divide;
    
    //controls when the accumulator is reset and when to divide the result
    average_4vals_fsm FSM(  
        .clk(clk), 
        .reset_n(reset_n),
        .divide(divide),
        .resetAdder(resetAdder)
    );  
    
    accumulator #(.N(26)) ADDER(
        .load(1),   //always accumulate (because we are always getting the next value in the MEMORY)
        .clk(clk), 
        .reset_n(~resetAdder),   //reset once we added all four of them
        .add_sub(0),
        .X(data_r),
        .Q(sum)
    );
    
    // increment the addr_r every time there is a new measurement
    always @(posedge clk)
    begin
        if (~reset_n)
            addr_r <= 2'b00;
        else
            addr_r <= addr_r + 1;
        if (divide)
            average <= {2'b00, sum[25:2]}; //(sum >> 2); //divide by 4 to get the average from the cumulative sum
        else
            average <= average;
    end
    
endmodule
