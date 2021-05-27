`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 02:26:29 PM
// Design Name: 
// Module Name: game_fsm_tb
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


module game_fsm_tb(

    );
    reg clk, reset_n;
    reg start, P1_in, P2_in;
    reg [7:0] rand;
    wire [7:0] P1_num, P2_num;
    wire [1:0] P1_rounds, P2_rounds, P_turn, winner;
    
game_fsm UUT(
    .clk(clk), .reset_n(reset_n),                 // required system inputs
    .start(start), .P1_in(P1_in), .P2_in(P2_in),          // game inputs from buttons
    .rand(rand),                   // random number from LFSR
    .P1_num(P1_num), .P2_num(P2_num),    // stored numbers for P1 and P2
    .P1_rounds(P1_rounds), .P2_rounds(P2_rounds),     // number of rounds each player won
    .P_turn(P_turn), .winner(winner)         // player that has the next turn and player that won the game
    );
    
    // create clock
    localparam T = 10;
    always
    begin
        clk = 0;
        rand = $urandom_range(0,255);
        #(T/2);
        clk = 1;
        #(T/2);
    end
    
    initial
    begin
        reset_n = 0;
        
        #T reset_n = 1;
        
        start = 0;
        P1_in = 0;
        P2_in = 0;
        
        // test start button and null effects of P1_in and P2_in before start button is pressed
        #(3*T);
//        #(T/2);
        P1_in = 1;
        #T;
        P1_in = 0;
        P2_in = 1;
        #T;
        P2_in = 0;
        
        #T start = 1;
        #T start = 0;
        
        // test null effects of P2_in while it is P1's turn
        #T P2_in = 1;
        #T P2_in = 0;
        
        // test P1_in
        #T P1_in = 1;
        #T P1_in = 0;
        
        // test P2_in
        #(3*T) P2_in = 1;
        #T P2_in = 0;
        
        // do another round
        #(2*T) P1_in = 1;
        #T P1_in = 0;
        #T P2_in = 1;
        #T P2_in = 0;
        
        // do one last round
        #(2*T) P1_in = 1;
        #T P1_in = 0;
        #T P2_in = 1;
        #T P2_in = 0;
        #T $finish;
        
        
    end
    
    
    
    
endmodule
