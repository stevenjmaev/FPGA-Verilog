`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2021 02:04:04 PM
// Design Name: 
// Module Name: parking_lot
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


module parking_lot(
    input a,
    input b,
    input clk,
    input reset_n,
    output car_enter,
    output car_exit
    );

 reg [3:0] state_reg, state_next;
    localparam s0 = 0;
    localparam s1 = 1;
    localparam s2 = 2;
    localparam s3 = 3;
    localparam s4 = 4;
    localparam s5 = 5;
    localparam s6 = 6;
    localparam s7 = 7;
    localparam s8 = 8;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        case(state_reg)
            s0: 
                case({a,b})
                  2'b00:
                    state_next = s0;
                  2'b01:
                    state_next = s5;
                  2'b10:
                    state_next = s1;
                  2'b11:
                    state_next = s0;
                  endcase
            s1: 
                case({a,b})
                  2'b00:
                    state_next = s0;                   
                  2'b11:
                    state_next = s2;
                  default: state_next = state_reg;
                  endcase             
            s2: 
                case({a,b})
                  2'b01:
                    state_next = s3;                   
                  2'b10:
                    state_next = s1;
                  default: state_next = state_reg;
                  endcase
           s3: 
                case({a,b})
                  2'b00:
                    state_next = s4;                   
                  2'b11:
                    state_next = s2;
                  default: state_next = state_reg;
                  endcase
           
           s4: state_next = s0;
                   
                  
           s5: 
                case({a,b})
                  2'b00:
                    state_next = s0;
                  2'b11:
                    state_next = s6;
                  default: state_next = state_reg;
                  endcase
            s6: 
                case({a,b})
                  2'b01:
                    state_next = s5;                   
                  2'b10:
                    state_next = s7;
                  default: state_next = state_reg;
                  endcase             
            s7: 
                case({a,b})
                  2'b00:
                    state_next = s8;                   
                  2'b11:
                    state_next = s6;
                  default: state_next = state_reg;
                  endcase
                  
           s8: state_next = s0;                   
 
         default: state_next = s0; 
        endcase
    end
    
    assign car_enter = (state_reg == s4);
    assign car_exit = (state_reg == s8);
    
endmodule