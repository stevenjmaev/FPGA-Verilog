`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2021 09:27:42 AM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
    input [7:0] bin,
    output[11:0] bcd
    );
    
    wire [3:0]s1;
    wire [3:0]s2;
    wire [3:0]s3;
    wire [3:0]s4;
    wire [3:0]s6;
    
    //Assignments of Constant Values
    assign bcd[0]   = bin[0];   //Assigns output to the first ones place
    assign bcd[9]   = s6[3];    //Assigns output to the third highest hundreds place
    assign bcd[10]  = 1'b0;     //Assigns output to the second highest hundreds place
    assign bcd[11]  = 1'b0;     //Assigns output to the highest hundreds place
    
    
    //Instantiation of the code
    add_3 add3_1(
        .A({0, bin[7:5]}),
        .S(s1)
    );
    
    add_3 add3_2(
        .A({s1[2:0], bin[4]}),
        .S(s2)
    );
    
    add_3 add3_3(
        .A({s2[2:0], bin[3]}),
        .S(s3)
    );
    
    add_3 add3_4(
        .A({s3[2:0], bin[2]}),
        .S(s4)
    );  
    
    add_3 add3_5(
        .A({s4[2:0], bin[1]}),
        .S(bcd[4:1])
    );
    
    add_3 add3_6(
        .A({0, s1[3], s2[3], s3[3]}),
        .S(s6)
    );
    
    add_3 add3_7(
        .A({s6[2:0], s4[3]}),
        .S(bcd[8:5])
    );        
    
endmodule
