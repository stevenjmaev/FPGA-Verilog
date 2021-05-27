`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 05:29:09 PM
// Design Name: 
// Module Name: freq_memory_tb
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


module freq_memory_tb(

    );
    // "inputs and outputs"
    reg squareWave, reset_n, clk;
    reg [1:0] addr_read;
    wire [$clog2(50_000_000)-1:0] data_r;
    
    // instantiate UUT
    
    freq_memory UUT(
        .clk(clk), .reset_n(reset_n),
        .waveform(squareWave),
        .addr_r(addr_read),
        .data_r(data_r)
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
    
    // create waveform with certain frequency
    localparam wavePeriod0 = 400;   // wave period is 250ns (frequency is 2_500_000.0 Hz)
    localparam wavePeriod1 = 237;   // wave period is 237ns (frequency is 4_219_409.2 Hz)
    localparam wavePeriod2 = 500;   // wave period is 250ns (frequency is 2_000_000.0 Hz)
    localparam wavePeriod3 = 1300;  // wave period is 250ns (frequency is 0_769_230.7 Hz)
    
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
        
        #clkPeriod addr_read = 2'b00;
        #clkPeriod addr_read = 2'b01;
        #clkPeriod addr_read = 2'b10;
        #clkPeriod addr_read = 2'b11;
        #(500_000*clkPeriod);
        $finish;
    end
endmodule
