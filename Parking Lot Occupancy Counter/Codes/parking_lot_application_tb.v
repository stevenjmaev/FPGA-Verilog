`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2021 03:13:19 PM
// Design Name: 
// Module Name: parking_lot_application_tb
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


module parking_lot_application_tb(

    );
    
    //1) Declaration Section
    reg a_out;
    reg b_out;
    reg reset_n_out;
    reg clk;
    wire AN_index;
    wire sseg;

    
 
    //2) Module Instantiation
   parking_lot_application uut(
    .a(a_out),
    .b(b_out),
    .clk(clk),
    .reset_n(reset_n_out),
    .AN_index(AN_index),
    .sseg(sseg),
    .DP()
    );
    
    //3) Timer (Stopwatch)
    initial 
    begin
        #1000 $finish;   
    end
    
    //4) Generate Stimuli
    //Generating a clk signal
    localparam T = 10;
    always
    begin
        clk = 1'b0;
        #(T / 2);
        clk = 1'b1;
        #(T / 2);
    end
    
    initial 
    begin
        //Toggle Reset
        reset_n_out = 1'b0;
        #T reset_n_out = 1'b1;
               
//        //Car Enters, but hesitates and backs out
//        //Go from S0 to S1, S2, S3, S2, S1, S0
//        #T a_out = 1'b1;	
//           b_out = 1'b0;	//s1
//        #(13*T);
//        #T a_out = 1'b1;	
//           b_out = 1'b1;	//s2
//        #(13*T);
//        #T a_out = 1'b0;	
//           b_out = 1'b1;	//s3
//        #(13*T);
////        #T a_out = 1'b0;	
////           b_out = 1'b0;	//s4 ->s0
//        #(13*T);        
//        #T a_out = 1'b1;	
//           b_out = 1'b1;	//back to s2
//        #(13*T);    
//        #T a_out = 1'b1;	
//           b_out = 1'b0;	//back to s1
//        #(13*T);
//        #T a_out = 1'b0;	
//           b_out = 1'b0;	//back to s0
//        #(13*T);
//        #T;
//        #T;

        //Car begins to leave, then returns to parking lot
        // Go from S0 to S5, S6, S7, S6, S5, S0
        #T a_out = 1'b0;	
            b_out = 1'b1;	//s5
        #(11*T);
        #T a_out = 1'b1;	
           b_out = 1'b1;	//s6
        #(11*T);
        #T a_out = 1'b1;	
           b_out = 1'b0;	//s7
        #(11*T);
        #T a_out = 1'b1;	
           b_out = 1'b1;	//back to s6
        #(11*T);    
        #T a_out = 1'b0;	
           b_out = 1'b1;	//back to s5
        #(11*T);
        #T a_out = 1'b0;	
           b_out = 1'b1;	//back to s0
        #(11*T);
        #T;
        #T;  



        
        //Car Leaves
        #T a_out = 1'b0;	
        b_out = 1'b1;	//s5
        #(10*T);
        #T a_out = 1'b1;	
           b_out = 1'b1;	//s6
        #(10*T);
        #T a_out = 1'b1;	
           b_out = 1'b0;	//s7
        #(10*T);
        #T a_out = 1'b0;	
           b_out = 1'b0;	//s8 ->s0
        #(10*T);
        #T;
        #T;      
                
        //Car Enters
        #T a_out = 1'b1;	
           b_out = 1'b0;	//s1
        #(10*T);
        #T a_out = 1'b1;	
           b_out = 1'b1;	//s2
        #(10*T);
        #T a_out = 1'b0;	
           b_out = 1'b1;	//s3
        #(10*T);
        #T a_out = 1'b0;	
           b_out = 1'b0;	//s4 ->s0
        #(10*T);                   
        #T $finish;    
        
    end
    
    
endmodule
