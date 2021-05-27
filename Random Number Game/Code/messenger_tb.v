`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2021 02:35:14 PM
// Design Name: 
// Module Name: messenger_tb
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


module messenger_tb(

    );
    reg clk, reset_n;
    reg start;
    
ASCII_messenger UUT(
    .clk(clk), .reset_n(reset_n),
    .msg_index(4'b0000),
    .start(start),
    .rx(),
    .UART_empty(),
    .tx(),
    .done()
    );
    
    // create clock
    localparam T = 10;
    always
    begin
        clk = 0;
        #(T/2);
        clk = 1;
        #(T/2);
    end
    
    initial
    begin
        reset_n = 0;
        
        #T reset_n = 1;
        
        start = 0;
        
        // test start button and null effects of P1_in and P2_in before start button is pressed
        #(3*T);
        
        #T start = 1;
        #T start = 0;
        #(15*T)
        #T $finish;
        
        
    end
    
    
    
    
endmodule
