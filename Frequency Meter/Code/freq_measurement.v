`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 10:35:30 AM
// Design Name: 
// Module Name: freq_measurement
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


module freq_measurement(
    input waveform,
    input clk,
    input reset_n,
    output done,        // active when the measurement is done
    output [$clog2(50_000_000)-1:0] frequency
    );
    
    wire p_edge, timerDone, timerReset, countEnable, countReset;
    wire [$clog2(50_000_000)-1:0] edgeCount;
    edge_detector E_DETECTOR(
        .clk(clk), 
        .reset_n(reset_n),
        .level(waveform),
        .p_edge(p_edge), 
        .n_edge(), 
        ._edge()
    );
    
    freq_measurement_fsm FSM(
        .p_edge(p_edge),            // tells the FSM that a posedge occured
        .timerDone(timerDone),      // tells the FSM that the timer has finished
        .clk(clk),                  // the system clock
        .reset_n(reset_n),          // system reset
        .countReset(countReset),    // reset the counter
        .count(countEnable)         // tell the counter to increment
    );
    
    // for a max frequency of 100MHz and a window of 500ms, we need a max count of 50,000,000
    udl_counter  #(.BITS($clog2(50_000_000))) COUNTER(
        .clk(clk),
        // I figured out the line below using a truth table...
        .reset_n((~countReset) & reset_n),    // reset when the FSM says to reset or when the reset button is pressed
        .enable(countEnable),
        .up(1),
        .load(0),
        .D(1),
        .Q(edgeCount)   
    );
    
    timer_parameter #(.FINAL_VALUE(50_000_000)) TIMER(
//    timer_parameter #(.FINAL_VALUE(500_000)) TIMER(    //for testbench simulation (instead of 500ms it should be 500us)
        .clk(clk),
        .reset_n(reset_n),
        .enable(1),
        .done(timerDone)
    );
    
    assign frequency = (edgeCount << 1);
    assign done = timerDone;
endmodule
