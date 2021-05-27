`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 04:27:42 PM
// Design Name: 
// Module Name: morse_decoder_fsm
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


module morse_decoder_fsm_revised
    #(parameter BITS = 5) (

        input b,
        input clk,
        input reset_n,
        input [BITS-1:0] count,
        output dot,
        output dash,
        output LG,
        output WG,
        output count_reset
        
    );
    
    reg [3:0] state_reg, state_next;
	localparam s_idle = 7;
    localparam s0 = 0;
    localparam s1 = 1;
    localparam s2 = 2;
    localparam s3 = 3;
    localparam s4 = 4;
    localparam s5 = 5;
    localparam s6 = 6;

    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= s_idle;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        case(state_reg)
			s_idle: 
				if (b)
					state_next = s0;
				else
					state_next = state_reg;
            s0:
                if(b)
                    state_next = s1;
                else
                    state_next = s4;
            s1: 
                if(b)
                    if(count < 1)
                        state_next = state_reg;
                    else
                        state_next = s2;
                else
                    state_next = s0;            
            s2:
                if(b)
                    if(count < 3)
                        state_next = state_reg;
                    else
                        state_next = s3;
                else
                    state_next = s0;               
            s3:
                if(b)
                    state_next = state_reg;
                else
                    state_next = s0;                
            s4:
                if(~b)
                    if(count < 3)
                        state_next = state_reg;
                    else
                        state_next = s5;
                else
                    state_next = s0;               
            s5:
                if(~b)
                    if(count < 7)
                        state_next = state_reg;
                    else
                        state_next = s6;
                else
                    state_next = s0;    
            s6:
                if(count < 20)
                    if(~b)
                        state_next = state_reg;
                    else
                        state_next = s0;
                else
                    state_next = s_idle;    
         
         default: state_next = s0; 
        endcase
    end
    
    //Assignment of Outputs
    assign dot  = (state_reg == s2 & ~b);
    assign dash = (state_reg == s3 & ~b);
    assign LG   = (state_reg == s5 & b);
    assign WG   = (state_reg == s6 & (b & count < 20)) | (state_reg == s6 & count >= 20);
    assign count_reset = (state_reg == s0) | (state_reg == s_idle); 
    
endmodule
