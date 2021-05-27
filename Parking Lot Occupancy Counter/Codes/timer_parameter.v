`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2021 01:45:32 PM
// Design Name: 
// Module Name: timer_parameter
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


module timer_parameter
    #(parameter FINAL_VALUE = 255) // Change parameter to change the clock cycle length. This is static though.
    (
    input clk,
    input reset_n,
    input enable,
    //    output [BITS - 1:0] Q, // we don't care about the value of the counter
    output done     //We really care about this "done" value. Called a ticker.
    );
    
    //This is really just the modulus counter modified a little bit to make us care about the "done" variable
    
    localparam BITS = $clog2(FINAL_VALUE);
    
    reg [BITS - 1:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    // Next state logic
    assign done = Q_reg == FINAL_VALUE; //Counts all the way to the final value

    always @(*)
        Q_next = done? 'b0: Q_reg + 1;
    
    
endmodule