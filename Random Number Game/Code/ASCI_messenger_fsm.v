`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2021 03:14:53 PM
// Design Name: 
// Module Name: ASCI_messenger_fsm
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


module ASCI_messenger_fsm(
    input clk, reset_n,
    input start, 
    input [3:0] count,
    output resetCounter, wr_en, count_en
    );
    
    localparam S0 = 0, S1 = 1, S2 = 2;   
    reg [1:0] state_reg, state_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= 0;
        else 
        begin
            state_reg <= state_next;
        end
    end
    
    always @(*)
    begin
    state_next = state_reg;
        case (state_reg)
            S0:
                if (start)
                    state_next = S1;
            S1:
                state_next = S2;
            S2:
                if (count == 4'b1111)
                    state_next = S0;
                else
                    state_next = S1;
            default: state_next = state_reg;
        endcase
    end
    
    assign resetCounter = (state_reg == S0);
    assign wr_en = (state_reg == S2);
    assign count_en = (state_reg == S1);
    
    
endmodule
