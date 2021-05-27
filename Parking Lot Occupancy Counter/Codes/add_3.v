`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2021 08:06:44 AM
// Design Name: 
// Module Name: add_3
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


module add_3(
    input [3:0] A,
    output reg [3:0] S 
    );
     
    always@(A)
    begin
        S=A;//Returns the same value
        case(A[3]) 
            //Needs to add +3
            1: S = A + 4'b0011;            
            0: case(A[2:0])
                3'b101:    S = A + 4'b0011;
                3'b110:    S = A + 4'b0011;
                3'b111:    S = A + 4'b0011;
                default: S=A;
                endcase
            default S=A;//Returns the same value
        endcase
    end    
endmodule
