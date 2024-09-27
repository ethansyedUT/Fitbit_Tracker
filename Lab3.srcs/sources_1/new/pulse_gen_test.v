`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 03:09:01 AM
// Design Name: 
// Module Name: pulse_gen_test
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

module pulse_gen_test(
    input wire clk,          // Board clock input
    input wire [3:0] sw,   // Mode selection switches
    output wire [0:0] led    // LED output for pulse visualization
);

    // Simple clock divider
    reg [1:0] clk_div_counter = 0;
    wire slow_clk;

    always @(posedge clk) begin
        clk_div_counter <= clk_div_counter + 1;
    end

    assign slow_clk = clk_div_counter[1];  // This creates a clock of about 3 Hz
        // Instantiate the pulse_gen module
    pulse_gen pulse_generator(
        .clk(clk),
        .rst(sw[1]),
        .start(sw[0]),
        .mode(sw[3:2]),
        .pulse(led[0])    // Connect pulse directly to LED output
    );
endmodule
