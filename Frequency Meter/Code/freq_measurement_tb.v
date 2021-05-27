`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 11:03:32 AM
// Design Name: 
// Module Name: freq_measurement_tb
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


module freq_measurement_tb(

    );
    // "inputs and outputs"
    reg squareWave, reset_n, clk;
    wire [$clog2(50_000_000)-1:0] freq;
    wire done;
    
    // instantiate UUT
    
    freq_measurement UUT(
        .waveform(squareWave),
        .clk(clk),
        .reset_n(reset_n),
        .done(done),
        .frequency(freq)
    );  
    
    // create clock with period of 10ns
    localparam clkPeriod = 10; 
    always
    begin
        clk = 1'b0;
        #(clkPeriod / 2);
        clk = 1'b1;
        #(clkPeriod / 2);
    end
    
    // create waveform with certain frequency
    localparam wavePeriod1 = 1300;    // wave period is 1300ns (frequency is 769_230.8 Hz)
//    localparam wavePeriod1 = 237;    // wave period is 237ns (frequency is 4_219_409.2 Hz)
    always
    begin
        squareWave = 1'b0;
        #(wavePeriod1 / 2);
        squareWave = 1'b1;
        #(wavePeriod1 / 2);
    end
    
    // reset the system at the start, and then let it run...
    initial 
    begin
        reset_n = 1'b0;
        #clkPeriod reset_n = 1'b1;
        #(500_000_010*clkPeriod);     
        $finish;
    end
endmodule