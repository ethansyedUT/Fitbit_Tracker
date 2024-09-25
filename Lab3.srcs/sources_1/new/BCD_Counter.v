`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 08:32:12 PM
// Design Name: 
// Module Name: BCD_Counter
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


module BCD_Counter(
    input wire [3:0] data,
    input wire en, ld, up, clr, clk,
    output wire [3:0] result,
    output reg CO
    );
    reg [3:0] save = 0;
    always @(posedge clk or posedge clr)begin
        if(clr)begin
            save <= 0;
            CO <= 0;
        end else if (en)begin
            if(ld)begin
                save <= (data>9) ? 4'b0000 : data;
                CO <= 0;
            end else if(up) begin
                if(save >= 9)begin
                    save <= 0;
                    CO <= 1;
                end else begin              
                    save <= save + 1;
                    CO <= 0;
                end     
            end else begin
                if(save == 0)begin
                    save <= 9;
                    CO <= 1;
                end else begin              
                    save <= save -1;
                    CO <= 0;
                end
            end
        end else begin
            CO <= 0;
        end
    end
    
    assign result = save;  
      
endmodule
