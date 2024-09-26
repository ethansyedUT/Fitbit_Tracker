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
    output reg [13:0] value // will switch between the 4 desired vals every 2 sec
);
    // Second generator
    wire sec_pulse;
    reg [25:0]seconds = 0; // enough seconds to hold a year if you wanted
    sec_gen sec(.clk(clk), .slowClk(sec_pulse));
    
    ////////////////////////////////////////////////////////////////////////
    
    // General Internal Regs
    reg [13:0] step_count;  // total (Can exceed 9999 but sys should detect and saturate sys until rst
    
    reg [13:0] dist;        // Miles walked (0.5 mi increments)
    
    reg [6:0] walk9_count;  // For first 9 sec (start/rst) # of secs over 9
    
    reg [13:0] highAct_sec; //total consistent seconds >= 60 of high activity
    reg [13:0] last_count = 0; //logic has potential for OVF i will not account for
    reg [6:0] consecHA = 0;
    reg highActFlag = 0;
    
    reg [1:0] state; // what state to send to output
    ////////////////////////////////////////////////////////////////////////

    // Combinational
    always @(*) begin
        //Switching output vals every 2 sec
        if(seconds % 2 == 0 && seconds != 0)begin
            state = state + 1;
        end
        
        // State 2 logic
        dist <= (step_count*5)/2048; // display this value as (value * 0.1)
        
        case(state)
            2'b00: value = step_count;
            2'b01: value = dist;
            2'b10: value = {7'b0, walk9_count};
            2'b11: value = highAct_sec;
         endcase
    end
    
    // Sequential
    always @(posedge sec_pulse or posedge rst)begin
        if (rst) begin
            step_count <= 0;
            dist <= 0;
            walk9_count <= 0;
            highAct_sec <= 0;
            last_count <= 0;
            consecHA <= 0;
            highActFlag <= 0;
            state <= 0;
        end else begin
            seconds = seconds + 1;
            // State 3
            if(step_count > seconds * 32 && seconds < 10)
                walk9_count <= walk9_count + 1;
            
            // Calculating steps since last sec
            if(step_count - last_count >= 64)
                consecHA = consecHA + 1;
            else 
                consecHA = 0;
            last_count <= step_count;   // reset step/sec counter
                
            // State 4
            if(consecHA == 60)begin
                highAct_sec <= highAct_sec + 60;
            end else if(consecHA > 60)
                highAct_sec <= highAct_sec + 1;
        end
        
    end
    
    always @(posedge pulse or posedge rst)begin
        if (rst) begin
            step_count <= 0;
            dist <= 0;
            walk9_count <= 0;
            highAct_sec <= 0;
            last_count <= 0;
            consecHA <= 0;
            highActFlag <= 0;
            state <= 0;
        end
        else
            step_count <= step_count + 1;
    end
 


endmodule