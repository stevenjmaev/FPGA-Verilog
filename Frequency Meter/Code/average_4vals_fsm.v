`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2021 02:53:41 PM
// Design Name: 
// Module Name: average_4vals_fsm
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


module average_4vals_fsm(
    input clk, reset_n,
    output divide,
    output resetAdder
    );  
    
    localparam s0 = 3'd0;
    localparam s1 = 3'd1;
    localparam s2 = 3'd2;
    localparam s3 = 3'd3;
    localparam s4 = 3'd4;
    localparam s5 = 3'd5;
    
    reg[2:0] state_reg, state_next;
    always @(posedge clk)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        if (state_reg == s5)
            state_next = s0;
        else
            state_next = state_reg + 1; 
    end
    
    assign divide = (state_reg == s5);
    assign resetAdder = (state_reg == s0);
endmodule