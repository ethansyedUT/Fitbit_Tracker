`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 07:42:19 PM
// Design Name: 
// Module Name: sec_gen
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


module sec_gen(clk, slowClk);
  input clk; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 1;
    slowClk = 0;
  end

  always @ (posedge clk)
  begin
    if(counter == 100_000_000) begin
      counter <= 1;
      slowClk <= 1;
    end
    else begin
      counter <= counter + 1;
      slowClk <= 0;
    end
  end

endmodule
