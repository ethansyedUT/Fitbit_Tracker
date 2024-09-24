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
    output wire [3:0] result, CO
    );
    reg overflow = 0;
    reg [3:0] save = 0;
    always @(posedge clk or posedge clr)begin
        overflow <= 0;
        if(clr)begin
            save <= 0;
            overflow <= 0;
        end else if (en)begin
            if(ld)begin
                if(data > 9)
                    save <= 0;
                else
                    save <= data;
            end else begin
                if(up)begin
                    if(save >= 9)begin
                        save <= 0;
                        overflow <= 1;
                    end else begin              
                        save <= save + 1;
                        overflow <= 0;
                    end
                end else begin
                    if(save == 0)begin
                        save <= 9;
                        overflow <= 1;
                    end else begin              
                        save <= save -1;
                        overflow <= 0;
                    end
                end
            end
        end
    end
        
    
    assign result = save;
    assign CO = overflow;
    
    
    
endmodule
