`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 10:02:39 AM
// Design Name: 
// Module Name: freq_measurement_fsm
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


module freq_measurement_fsm(
    input clk, reset_n,
    input p_edge,           // tells the FSM that a posedge occured
    input timerDone,        // tells the FSM that the timer has finished
    output timerReset,      // reset the timer
    output countReset,
    output count            // tell the counter to increment
    );
    
    localparam s0 = 2'd0;
    localparam s1 = 2'd1;
    localparam s2 = 2'd2;
    
    reg [1:0] state_reg, state_next;
    
    always @(posedge clk)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        case(state_reg)
            s0: case(p_edge)
                    1'b0: state_next = s0;
                    1'b1: state_next = s1;
                    default: state_next = s0;
                endcase
            s1: casex({timerDone, p_edge})
                    2'b00: state_next = s2;
                    2'b01: state_next = s1;
                    2'b1x: state_next = s0;
                    default: state_next = s0;
                endcase
            s2: casex({timerDone, p_edge})
                    2'b00: state_next = s2;
                    2'b01: state_next = s1;
                    2'b1x: state_next = s0;
                    default: state_next = s0;
                endcase                    
            default: state_next = s0;
        endcase
    end
    
    assign count = (state_reg == s1);
    assign timerReset = (state_reg == s0);
    assign countReset = (state_reg == s0);
endmodule
