`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2021 02:41:06 PM
// Design Name: 
// Module Name: parking_lot_application
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


module parking_lot_application(
    input a,
    input b,
    input clk,
    input reset_n,
    
    output [7:0] AN_index,
    output [6:0] sseg,
    output DP
    );

    wire car_enter, car_exit;
    wire [7:0] counter_output;
    wire [11:0] bcdNum;
    wire [3:0] bcdOnes, bcdTens, bcdHundreds;
    
    button reset_n_button(
        .clk(clk),
        .in(reset_n),
        .out(reset_n_out)
    );
    
    debouncer_delayed a_button_input(
        .clk(clk), 
        .reset_n(~reset_n_out),
        .noisy(a),
        .debounced(a_out)
    );
    
    debouncer_delayed b_button_input(
        .clk(clk), 
        .reset_n(~reset_n_out),
        .noisy(b),
        .debounced(b_out)
    );
    
    
//    button a_input(
//        .clk(clk),
//        .in(a),
//        .out(a_out)
//    );
    
//    button b_input(
//        .clk(clk),
//        .in(b),
//        .out(b_out)
//    );
    
    parking_lot lot_1_gate(
        .a(a_out),
        .b(b_out),
        .clk(clk),
        .reset_n(~reset_n_out),
        .car_enter(car_enter),
        .car_exit(car_exit)
    ); 
    
    udl_counter#(.BITS(8)) lot_1_gate_counter(
        .clk(clk),
        .reset_n(~reset_n_out),
        .enable((car_enter | car_exit)),
        .up(car_enter), //when asserted the counter is up counter; otherwise, it is a down counter
        .load(1'b0),
        .D(),
        .Q(counter_output)
    );   
    
    bin2bcd bin_bcd_converter(
        .bin(counter_output),
        .bcd(bcdNum)
    ); 

    assign bcdOnes = bcdNum[3:0];
    assign bcdTens = bcdNum[7:4];
    assign bcdHundreds = bcdNum[11:8];
    
    sseg_driver lot_1_sseg(
        .I0(0), 
        .I1(0), 
        .I2(0), 
        .I3(0),
        .I4(0),
        .I5({(|bcdHundreds),bcdHundreds, 1'b0}),        //we only want the hundreds if they are nonzero
        .I6({(|(bcdHundreds|bcdTens)),bcdTens,1'b0}),   //we only want the ten's place if tens and hundreds are nonzero
        .I7({1'b1,bcdOnes,1'b0}),                       //we always want the one's place on
        .clk(clk), 
        .reset_n(~reset_n_out),
        //Outputs
        .AN(AN_index),
        .sseg(sseg),
        .DP(DP)
    );
    
    
    
    
    
endmodule
