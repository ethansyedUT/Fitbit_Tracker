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
    //sw[3:2] = Mode
    //sw[1] = Reset
    //sw[0] = Start
    
    //led[0] - SI (>9999 step overflow)
    
    // Initialize a pulse generator module
    // Initialize a fitbit tracker module
    // Take output of fitbit tracker and feed into BCD
    // Feed output of BCD into 7-seg display MUX
endmodule
