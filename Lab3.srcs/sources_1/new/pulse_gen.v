`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:45:38 PM
// Design Name: 
// Module Name: pulse_gen
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


module pulse_gen(
    input wire clk, rst, start, [1:0] mode,
    output reg pulse
);
    //internal clk divider
    // Parameters for different frequencies
    localparam FREQ_32HZ  = 32;
    localparam FREQ_64HZ  = 64;
    localparam FREQ_128HZ = 128;
    localparam FREQ_100MHZ = 100_000_000;
    
    // clk div counter
    reg[27:0] clk_counter = 0;
    reg[27:0] threshold = 0;
    
    //Second Tracker for hybrid mode
    reg [7:0] sec_elapsed = 0;
    reg [27:0] second_counter = 0;
    
    // ROM to hold our pulse schedule
    reg [12:0] pulse_schedule [12:0];
    initial begin
        pulse_schedule[0]  = 20;
        pulse_schedule[1]  = 33;
        pulse_schedule[2]  = 66;
        pulse_schedule[3]  = 27;
        pulse_schedule[4]  = 70;
        pulse_schedule[5]  = 30;
        pulse_schedule[6]  = 19;
        pulse_schedule[7]  = 30;
        pulse_schedule[8]  = 33;
        pulse_schedule[9]  = 69;
        pulse_schedule[10] = 34;
        pulse_schedule[11] = 124;
        pulse_schedule[12] = 0;  // No pulses
    end
    // for t>144 seconds in hybrid mode be sure to pin t_elapsed to 145
    

    
    // Combinational
    always @(*) begin
         // Calculate Threshold / Pulse freq.
        case (mode)
            2'b00: threshold = FREQ_100MHZ / FREQ_32HZ / 2 - 1;
            2'b01: threshold = FREQ_100MHZ / FREQ_64HZ / 2 - 1;
            2'b10: threshold = FREQ_100MHZ / FREQ_128HZ / 2 - 1;
            2'b11: begin  // Hybrid mode
                if (sec_elapsed <= 8)
                    threshold = FREQ_100MHZ / pulse_schedule[sec_elapsed] / 2 - 1;
                else if (sec_elapsed <= 72)
                    threshold = FREQ_100MHZ / pulse_schedule[9] / 2 - 1;
                else if (sec_elapsed > 72 && sec_elapsed <= 78)
                    threshold = FREQ_100MHZ / pulse_schedule[10] / 2 - 1;
                else if (sec_elapsed <= 143)
                    threshold = FREQ_100MHZ / pulse_schedule[11] / 2 - 1;
                else
                    threshold = FREQ_100MHZ * 2 ;  // Threshold that will never be reached --> off
            
            end
        endcase
    end
    
    // Sequential
    always @(posedge clk) begin 
        if (rst || !start) begin
            clk_counter <= 0;
            second_counter <= 0;
            pulse <= 0;
            sec_elapsed <= 0;
        end else if(start)begin
            if (clk_counter >= threshold) begin
                clk_counter <= 0;
                pulse <= ~pulse;
            end else begin
                clk_counter <= clk_counter + 1;
            end
            
            if (second_counter == 100_000_000) begin
                second_counter <= 1;
                if (mode == 2'b11) begin
                    if (sec_elapsed < 144) 
                        sec_elapsed <= sec_elapsed + 1;
                    else
                        clk_counter <= 0;   // If sec >= 144 sec; elapsed_sec stays at 144 and clk_counter resets to 0 every second
                                            //      Therefore threshold is never met and led is off
                end else
                    sec_elapsed <= 0;   // handle switching back to hybrid mode 
            end else begin
                second_counter <= second_counter + 1;
            end
            
        end
    end

endmodule