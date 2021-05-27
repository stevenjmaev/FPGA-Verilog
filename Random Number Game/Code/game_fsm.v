`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 12:55:15 PM
// Design Name: 
// Module Name: game_fsm
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


module game_fsm(
    input clk, reset_n,                 // required system inputs
    input start, P1_in, P2_in,          // game inputs from buttons
    output [2:0] state,
    input [7:0] rand,                   // random number from LFSR
    output [7:0] P1_num, P2_num,    // stored numbers for P1 and P2
    output [1:0] P1_rounds, P2_rounds,     // number of rounds each player won
    output [1:0] winner,
    output reg [1:0] P_turn         // player that has the next turn and player that won the game
    );
    
    localparam S_IDLE = 0, S_P1 = 1, S_P2 = 2, S_COMPARE = 3, S_CHECK_WIN = 4;
    reg [2:0] state_reg, state_next;    // current and next states
    reg [1:0] P1_rounds_reg, P2_rounds_reg;     // number of rounds each player won
    reg [1:0] P1_rounds_next, P2_rounds_next;   // 
    reg [7:0] P1_num_reg, P2_num_reg, P1_num_next, P2_num_next;
    reg [1:0] winner_reg, winner_next;
    
    assign P1_rounds = P1_rounds_reg;
    assign P2_rounds = P2_rounds_reg;
    assign P1_num = P1_num_reg;
    assign P2_num = P2_num_reg;
    assign state = state_reg;
    assign winner = winner_reg;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
        begin
            state_reg <= S_IDLE;
            P1_rounds_reg <= 0;
            P2_rounds_reg <= 0;
            P1_num_reg<=0;
            P2_num_reg<=0;
            P1_num_reg <= 0;
            P2_num_reg <= 0;
            winner_reg <= 0;
        end
        else
        begin
            state_reg <= state_next;
            P1_rounds_reg <= P1_rounds_next;
            P2_rounds_reg <= P2_rounds_next;
            P1_num_reg <= P1_num_next;
            P2_num_reg <= P2_num_next;
            winner_reg <= winner_next;
        end
    end
    
    always @(*)
    begin
        // hold on to previous values by default
        P1_rounds_next = P1_rounds_reg;
        P2_rounds_next = P2_rounds_reg;
        P1_num_next = P1_num_reg;
        P2_num_next = P2_num_reg;
        winner_next = winner_reg;
        
        case (state_reg)
            S_IDLE:
            begin
                P_turn = 2'b00;
                if (start)
                    begin
                        state_next = S_P1;
                        P1_rounds_next = 0;
                        P2_rounds_next = 0;
                        P1_num_next = 0;
                        P2_num_next = 0;
                        winner_next = 2'b00;
                    end
                else
                begin
                    state_next = state_reg;
                end
            end
            
            S_P1:
            begin
                P_turn = 2'b01;
                if (P1_in)
                begin
                    P1_num_next = rand;
                    state_next = S_P2;
                end
                else
                    state_next = state_reg;
            end
            
            S_P2:
            begin
                P_turn = 2'b10;
                if (P2_in)
                begin
                    P2_num_next = rand;
                    state_next = S_COMPARE;
                end
                else
                    state_next = state_reg;
            end
            
            S_COMPARE:
            begin
                P_turn = 2'b00;
                if (P1_num_reg > P2_num_reg)            // compare stored numbers
                begin
                    P1_rounds_next = P1_rounds_reg + 1;
                    state_next = S_CHECK_WIN;
                end
                else
                begin
                    P2_rounds_next = P2_rounds_reg + 1;
                    state_next = S_CHECK_WIN; 
                end
            end
            
            S_CHECK_WIN:
            begin
                P_turn = 2'b00;
                if (P1_rounds_reg == 2'b10)         // check to see who won, then start game over again. 
                begin
                    winner_next = 2'b01;
                    state_next = S_IDLE;
                end
                else if (P2_rounds_reg == 2'b10)
                begin
                    winner_next = 2'b10;
                    state_next = S_IDLE;
                end
                else                        // if no player won yet, let P1 input again for another round
                    state_next = S_P1;
            end
           
            default: state_next = S_IDLE;
        endcase
      end   
    
    
endmodule
