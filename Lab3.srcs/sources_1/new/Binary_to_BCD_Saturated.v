`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 08:34:43 PM
// Design Name: 
// Module Name: Binary_to_BCD_Saturated
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

module Binary_to_BCD_Saturated(
    input wire [13:0] binary,
    output reg [3:0] thousands,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones,
    output reg SI
);
    always @(*) begin
        if (binary > 9999) begin  // 9999 in hex
            thousands = 4'd9;
            hundreds = 4'd9;
            tens = 4'd9;
            ones = 4'd9;
            SI = 1'b1;
        end else begin
            SI = 1'b0;
            thousands = binary / 1000;
            hundreds = (binary % 1000) / 100;
            tens = (binary % 100) / 10;
            ones = binary % 10;
        end
    end
endmodule