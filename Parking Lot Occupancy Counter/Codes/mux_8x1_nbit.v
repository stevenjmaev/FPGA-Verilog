`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2021 01:48:40 PM
// Design Name: 
// Module Name: mux_8x1_nbit
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


module mux_8x1_nbit
    #(parameter n = 6)(
    input [n - 1:0] x0, x1, x2, x3, x4, x5, x6, x7,
    input [2:0] select,
    output reg [n - 1:0] y
    );
    
    always @(*)
    begin
        case(select)
            3'd0: y = x0;
            3'd1: y = x1;
            3'd2: y = x2;
            3'd3: y = x3;
            3'd4: y = x4;
            3'd5: y = x5;
            3'd6: y = x6;
            3'd7: y = x7;
            default: y = 'bx;
        endcase
    end
endmodule
