`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:45:38 PM
// Design Name: 
// Module Name: FitBit_Tracker
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


module FitBit_Tracker(
    input wire pulse, clk, rst,
    output reg [13:0] value,
    output reg decOn
);


    // Second generator
    wire sec_pulse;
    reg [30:0] seconds = 0;
    sec_gen sec(.clk(clk), .slowClk(sec_pulse));
    
    // General Internal Regs
    reg [25:0] step_count = 0;
    reg [13:0] dist = 0;
    reg [6:0] walk9_count = 0;
    reg [13:0] highAct_sec = 0;
    reg [30:0] last_count = 0;
    reg [13:0] consecHA = 0; 
    reg [1:0] state = 0;
    
    // Main logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            step_count <= 0;
            dist <= 0;
            walk9_count <= 0;
            highAct_sec <= 0;
            last_count <= 0;
            consecHA <= 0;
            state <= 0;
            seconds <= 0;
            value <= 0;
        end else begin
            // Step count logic
            if (pulse) 
                step_count <= step_count + 1;
            
            // Second pulse logic
            if (sec_pulse) begin
                seconds = seconds + 1;
                
                // State switching logic 
                if (seconds % 2 == 0) begin // Very first state will only stay on for a second
                    state <= state + 1;
                end
                
                // Walk9 count logic
                if (step_count - last_count > 32 && seconds < 10) begin
                    walk9_count <= walk9_count + 1;
                end
                
                // High activity logic
                if (step_count - last_count >= 64) begin
                    consecHA <= consecHA + 1;
                    if (consecHA == 59) begin
                        highAct_sec <= highAct_sec + 60;
                    end else if (consecHA >= 60) begin
                        highAct_sec <= highAct_sec + 1;
                    end
                end else begin
                    consecHA <= 0;
                end
                
                last_count <= step_count;
            end
            
            // Update dist and value every clock cycle
            dist <= (step_count / 2048) * 5;
            
            case(state)
                2'b00: begin
                 value <= step_count;
                 decOn <= 0;
                end
                2'b01: begin
                    value <= dist;
                    decOn <= 1;
                end
                2'b10: begin
                    value <= {7'b0, walk9_count};
                    decOn <= 0;
                end
                2'b11: begin
                    value <= highAct_sec;
                    decOn <= 0;
                end
            endcase
        end
    end
endmodule
 


