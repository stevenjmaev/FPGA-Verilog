`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 12:56:10 PM
// Design Name: 
// Module Name: random_num_game
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


module random_num_game(
    input clk, reset_n,
    input P1, P2, start,
    output [6:0] sseg,
    output [7:0] AN_index,
    output DP,
    output reg [2:0] RGB_P1, RGB_P2,   
    input rx,
    output tx, UART_empty
    );
    
    // game wires
    localparam RNG_rate = 20_000_000;
    wire P1_debounced, P2_debounced, start_debounced;
    wire [7:0] rand, P1_num, P2_num;
    wire [1:0] P1_rounds, P2_rounds;
    wire [1:0] P_turn, winner;
    wire RNG_en;
    
    // display wires
    wire blue_flash, red, green;
    wire [4:0] blueFlash_count;
    wire blueFlash_counterEn;
    wire [11:0] BCD_P1_num, BCD_P2_num, BCD_rand;
    reg [11:0] P1_Display, P2_Display;
    
    // UART wires
    wire win_tick;
    reg [3:0] mssg;

// =========================== BUTTON DEBOUNCERS
button debouncer_P1(
    .clk(clk), .reset_n(reset_n),
    .noisy(P1),
    .debounced(),
    .p_edge(P1_debounced), .n_edge(), ._edge()
    );
    
button debouncer_P2(
    .clk(clk), .reset_n(reset_n),
    .noisy(P2),
    .debounced(),
    .p_edge(P2_debounced), .n_edge(), ._edge()
    );
    
button debouncer_start(
    .clk(clk), .reset_n(reset_n),
    .noisy(start),
    .debounced(),
    .p_edge(start_debounced), .n_edge(), ._edge()
    );
        
game_fsm GAME(
    .clk(clk), .reset_n(reset_n),                 // required system inputs
    .start(start_debounced), .P1_in(P1_debounced), .P2_in(P2_debounced),          // game inputs from buttons
    .rand(rand),                   // random number from LFSR
    .P1_num(P1_num), .P2_num(P2_num),    // stored numbers for P1 and P2
    .P1_rounds(P1_rounds), .P2_rounds(P2_rounds),     // number of rounds each player won
    .P_turn(P_turn), .winner(winner)         // player that has the next turn and player that won the game
    );
    
// =========================== RANDOM NUMBER GENERATOR    
lfsr #(.N(8)) RNG(
    .clk(clk),
    .reset_n(reset_n),
    .enable(RNG_en),
    .Q(rand)
    );

timer_parameter #(.FINAL_VALUE(RNG_rate)) RNG_timer(
    .clk(clk),
    .reset_n(reset_n),
    .enable(1),
    .done(RNG_en)
    );
    
// =========================== COLOR GENERATION
udl_counter #(.BITS(5)) blueFlash_counter(
    .clk(clk),
    .reset_n(reset_n),
    .enable(blueFlash_counterEn),
    .up(1), //when asserted the counter is up counter; otherwise, it is a down counter
    .load(0),
    .D(0),
    .Q(blueFlash_count)
    );  
    
timer_parameter #(.FINAL_VALUE(4_000_000)) blueFlash_timer(
    .clk(clk),
    .reset_n(reset_n),
    .enable(1),
    .done(blueFlash_counterEn)
    );
    
pwm_improved #(.R(8), .TIMER_BITS(8)) PWM_blueFlash(
    .clk(clk),
    .reset_n(reset_n),
    .duty(blueFlash_count), // Control the Duty Cylce
    .FINAL_VALUE('d200), // Control the switching frequency using Prescaler
    .pwm_out(blue_flash)
    );

pwm_improved #(.R(8), .TIMER_BITS(8)) PWM_green(
    .clk(clk),
    .reset_n(reset_n),
    .duty(2**5), // Control the Duty Cylce
    .FINAL_VALUE('d200), // Control the switching frequency using Prescaler
    .pwm_out(green)
    );
    
pwm_improved #(.R(8), .TIMER_BITS(8)) PWM_red(
    .clk(clk),
    .reset_n(reset_n),
    .duty(2**5), // Control the Duty Cylce
    .FINAL_VALUE('d200), // Control the switching frequency using Prescaler
    .pwm_out(red)
    );
    
// =========================== COLOR SELECTION
    always @(*)
    begin
        case (winner)
            2'b00: 
            begin
                if (P_turn == 2'd1)
                begin
                    RGB_P1 = {1'b0,green,1'b0};
                    RGB_P2 = {red,1'b0,1'b0};
                end
                else if (P_turn == 2'd2)
                begin
                    RGB_P1 = {red,1'b0,1'b0};
                    RGB_P2 = {1'b0,green,1'b0};
                end
            end
            2'b01:
            begin
                RGB_P1 = {1'b0,1'b0,blue_flash};
                RGB_P2 = {1'b0,1'b0,1'b0};
            end
            2'b10:
            begin
                RGB_P1 = {1'b0,1'b0,1'b0};
                RGB_P2 = {1'b0,1'b0,blue_flash};
            end
            default:
            begin
                RGB_P1 = 3'b0;
                RGB_P2 = 3'b0;
            end
        endcase
    end
    
// =========================== OUTPUT ASSIGNMENTS

bin2bcd #(.W(8)) bin2bcd_P1_num(
    .bin(P1_num),
    .bcd(BCD_P1_num)
    );
    
bin2bcd #(.W(8)) bin2bcd_P2_num(
    .bin(P2_num),
    .bcd(BCD_P2_num)
    );
    
bin2bcd #(.W(8)) bin2bcd_rand(
    .bin(rand),
    .bcd(BCD_rand)
    );
    
    always @(*)
    begin
        if (P_turn == 2'd1)
        begin
            P1_Display = BCD_rand;
            P2_Display = BCD_P2_num;
        end
        else if (P_turn == 2'd2)
        begin
            P1_Display = BCD_P1_num;
            P2_Display = BCD_rand;
        end
        else 
        begin
            P1_Display = BCD_P1_num;
            P2_Display = BCD_P2_num;
        end
    end
    
sseg_driver DISPLAY_DRIVER(
    // Player 2 stats
    .I0({1'b1, {2'b00,P2_rounds}, 1'b1}), 
    .I1({1'b1, P2_Display[11:8], 1'b0}), 
    .I2({1'b1, P2_Display[7:4], 1'b0}), 
    .I3({1'b1, P2_Display[3:0], 1'b0}), 
    
    // Player 1 stats
    .I4({1'b1, {2'b00,P1_rounds}, 1'b1}), 
    .I5({1'b1, P1_Display[11:8], 1'b0}), 
    .I6({1'b1, P1_Display[7:4], 1'b0}), 
    .I7({1'b1, P1_Display[3:0], 1'b0}), 
    
    .clk(clk), .reset_n(reset_n),
    .AN(AN_index),
    .sseg(sseg),
    .DP(DP)
    );
    
// =========================== UART

edge_detector winTicker (
    .clk(clk), .reset_n(reset_n),
    .level(|winner),
    .p_edge(win_tick), .n_edge(), ._edge()
    );

    always @(winner)
    begin
        if (winner == 2'b01)
            mssg = 4'b0000;
        else if (winner == 2'b10)
            mssg = 4'b0001;
        else 
            mssg = 4'b0000;
    end

ASCII_messenger terminalMessenger(
    .clk(clk), .reset_n(reset_n),
    .msg_index(mssg),
    .start(win_tick),
    .rx(rx),
    .tx(tx)
    );
    
endmodule
