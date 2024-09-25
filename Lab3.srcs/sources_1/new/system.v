`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:45:38 PM
// Design Name: 
// Module Name: system
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


module system(
    input clk,
    input [3:0] sw,
    output [6:0] seg,
    output [0:0] led
    );
    
    wire trackerOut;
    
    wire dummyLoad = 0;
    
    wire onesOVF;
    wire tensOVF;
    wire hundredsOVF;
    
    wire [15:0] BCD_In;
    wire [15:0] BCD_Out;
    
    
    //sw[3:2] = Mode
    //sw[1] = Reset
    //sw[0] = Start
    
    //led[0] - SI (>9999 step overflow)
    
    // Initialize a pulse generator module
    // Initialize a fitbit tracker module
    
    wire en_tens, en_hund, en_thou;
    assign en_tens = (sw[0] && dummyLoad) || (sw[0] && onesOVF);
    assign en_hund = (sw[0] && dummyLoad) || (sw[0] && tensOVF);
    assign en_thou = (sw[0] && dummyLoad) || (sw[0] && hundredsOVF);

    
    // Take output of fitbit tracker and feed into series BCD
    BCD_Counter ones (.clk(clk), .en(sw[0]), .ld(dummyLoad), .clr(sw[1]), .up(trackerOut), .data(BCD_In[3:0]),
                        .result(BCD_Out[0:3]), .CO(onesOVF));
                        
    BCD_Counter tens (.clk(clk), .en(en_tens), .ld(dummyLoad), .clr(sw[1]), .up(trackerOut), .data(BCD_In[7:4]),
                        .result(BCD_Out[7:4]), .CO(tensOVF));
                        
    BCD_Counter hundreds (.clk(clk), .en(en_hund), .ld(dummyLoad), .clr(sw[1]), .up(trackerOut), .data(BCD_In[11:8]),
                        .result(BCD_Out[11:8]), .CO(hundredsOVF));
                        
    BCD_Counter thousands (.clk(clk), .en(en_thou), .ld(dummyLoad), .clr(sw[1]), .up(trackerOut), .data(BCD_In[15:12]),
                        .result(BCD_Out[15:12]), .CO(onesOverflow));
                        
                        
                         
    
    // Feed output of BCD into 7-seg display MUX
    
    
    
endmodule
