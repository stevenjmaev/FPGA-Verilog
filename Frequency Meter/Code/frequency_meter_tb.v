`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2021 05:48:57 PM
// Design Name: 
// Module Name: frequency_meter_tb
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


module frequency_meter_tb(

    );
    // "inputs and outputs"
    reg squareWave, reset_n, clk;
    reg [1:0] addr_read;
    wire [6:0]sseg;
    wire [7:0]AN_index;
    wire dp;
    
    // instantiate UUT
    frequency_meter UUT(
    .clk(clk), .reset_n(reset_n),
    .waveform(squareWave),
    .sseg(sseg),
    .AN_index(AN_index),
    .dp(dp)  
    );  
    
    // create clock with period of 10ns
    localparam clkPeriod = 10; 
    integer tot_clkPulses = 0;  // keep track of how many clock pulses
    always
    begin
        clk = 1'b0;
        #(clkPeriod / 2);
        clk = 1'b1;
        #(clkPeriod / 2);
        tot_clkPulses = tot_clkPulses + 1;
    end
    
    always 
    begin
        squareWave = 1'b0;
            #(wavePeriod3 / 2);
            squareWave = 1'b1;
            #(wavePeriod3 / 2);
    end
    // create waveform with certain frequency
    localparam wavePeriod0 = 400;   // wave period is 400ns (frequency is 2_500_000.0 Hz)
    localparam wavePeriod1 = 237;   // wave period is 237ns (frequency is 4_219_409.2 Hz)
    localparam wavePeriod2 = 500;   // wave period is 500ns (frequency is 2_000_000.0 Hz)
    localparam wavePeriod3 = 1300;  // wave period is 1300ns (frequency is 0_769_230.7 Hz)
    localparam wavePeriod4 = 1555;  // wave period is 250ns (frequency is 0_769_230.7 Hz)
    
    // reset the system at the start, and then let it run...
    initial 
    begin
        reset_n = 1'b0;
        #clkPeriod reset_n = 1'b1;
        
        while(tot_clkPulses < 500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod0 / 2);
            squareWave = 1'b1;
            #(wavePeriod0 / 2);
        end
        
        while(tot_clkPulses < 2*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod1 / 2);
            squareWave = 1'b1;
            #(wavePeriod1 / 2);
        end
        
        while(tot_clkPulses < 3*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod2 / 2);
            squareWave = 1'b1;
            #(wavePeriod2 / 2);
        end
        
        while(tot_clkPulses < 4*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod3 / 2);
            squareWave = 1'b1;
            #(wavePeriod3 / 2);
        end
        
        while(tot_clkPulses < 5*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod4 / 2);
            squareWave = 1'b1;
            #(wavePeriod4 / 2);
        end
        
        while(tot_clkPulses < 6*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod1 / 2);
            squareWave = 1'b1;
            #(wavePeriod1 / 2);
        end
        
        while(tot_clkPulses < 7*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod2 / 2);
            squareWave = 1'b1;
            #(wavePeriod2 / 2);
        end
        
        while(tot_clkPulses < 8*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod3 / 2);
            squareWave = 1'b1;
            #(wavePeriod3 / 2);
        end
        while(tot_clkPulses < 9*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod4 / 2);
            squareWave = 1'b1;
            #(wavePeriod4 / 2);
        end
        
        while(tot_clkPulses < 10*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod1 / 2);
            squareWave = 1'b1;
            #(wavePeriod1 / 2);
        end
        
        while(tot_clkPulses < 11*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod2 / 2);
            squareWave = 1'b1;
            #(wavePeriod2 / 2);
        end
        
        while(tot_clkPulses < 12*500_001)
        begin
            squareWave = 1'b0;
            #(wavePeriod3 / 2);
            squareWave = 1'b1;
            #(wavePeriod3 / 2);
        end
        $finish;
    end
endmodule