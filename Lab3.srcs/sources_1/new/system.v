module system(
    input clk,
    input [3:0] sw,
    output [6:0] seg,
    output [3:0] an,
    output [0:0] led,
    output dp
    );
    
    wire decOn;
    wire pulse;
    wire [13:0] tracker_value;
    wire [3:0] bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones;
   
    
    
    //sw[3:2] = Mode
    //sw[1] = Reset
    //sw[0] = Start
    
    //led[0] - SI (>9999 step overflow)
    pulse_gen pulse_generator(
        .clk(clk),
        .rst(sw[1]),
        .start(sw[0]),
        .mode(sw[3:2]),
        .pulse(pulse)
    );

    // Fitbit tracker
    FitBit_Tracker fitbit_tracker(
        .pulse(pulse),
        .clk(clk),
        .rst(sw[1]),
        .value(tracker_value),
        .decOn(decOn)
    );

    // Instantiate Binary to BCD converter with saturation
    Binary_to_BCD_Saturated converter(
        .binary(tracker_value),
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .ones(bcd_ones),
        .SI(led[0])
    );
    
    // Seven Seg Controller
    Seven_Segment_Display_Controller display_ctrl(
        .clk(clk),
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .ones(bcd_ones),
        .decOn(decOn),
        .seg(seg),
        .an(an),
        .dp(dp)
    ); 
endmodule



