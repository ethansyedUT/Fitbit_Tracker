`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 08:37:44 PM
// Design Name: 
// Module Name: Seven_Segment_Display_Controller
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

module Seven_Segment_Display_Controller(
    input wire clk,
    input wire [3:0] thousands,
    input wire [3:0] hundreds,
    input wire [3:0] tens,
    input wire [3:0] ones,
    input wire decOn,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
);
    reg [1:0] digit_select;
    reg [16:0] refresh_counter;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 0) begin
            digit_select <= digit_select + 1;
        end
    end

    always @(*) begin
        case (digit_select)
            2'b00: begin
                an = 4'b1110;
                seg = seven_segment_encoder(ones);
                dp = 1'b1;
            end
            2'b01: begin
                an = 4'b1101;
                seg = seven_segment_encoder(tens);
                dp = ~decOn;
            end
            2'b10: begin
                an = 4'b1011;
                seg = seven_segment_encoder(hundreds);
                dp = 1'b1;
            end
            2'b11: begin
                an = 4'b0111;
                seg = seven_segment_encoder(thousands);
                dp = 1'b1;
            end
        endcase
    end

    function [6:0] seven_segment_encoder;
        input [3:0] bcd;
        begin
            case (bcd)
                4'h0: seven_segment_encoder = 7'b1000000;
                4'h1: seven_segment_encoder = 7'b1111001;
                4'h2: seven_segment_encoder = 7'b0100100;
                4'h3: seven_segment_encoder = 7'b0110000;
                4'h4: seven_segment_encoder = 7'b0011001;
                4'h5: seven_segment_encoder = 7'b0010010;
                4'h6: seven_segment_encoder = 7'b0000010;
                4'h7: seven_segment_encoder = 7'b1111000;
                4'h8: seven_segment_encoder = 7'b0000000;
                4'h9: seven_segment_encoder = 7'b0010000;
                default: seven_segment_encoder = 7'b1111111;
            endcase
        end
    endfunction
endmodule