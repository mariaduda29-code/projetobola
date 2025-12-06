module BouncingBall (
    input wire CLOCK_50,
    input wire [9:0] SW,        
    input wire [1:0] KEY,       
    
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
);


wire slow_clock_sig;
wire video_on_sig;
wire [9:0] pixel_x_int, pixel_y_int;
wire [9:0] ball_x_pos, ball_y_pos;
wire collision_active_sig;
wire [25:0] divisor_val_sig; 
wire key_random_pulse_sig;

Clock_Divider_Variable divider_inst (
    .clock_in(CLOCK_50), 
    .reset_n(KEY[0]), 
    .divisor_value(divisor_val_sig), 
    .clock_out(slow_clock_sig)
);


vga_sync vga_inst (
    .CLOCK_50(CLOCK_50),
    .RESET_N(KEY[0]), 
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .video_on(video_on_sig),
    .pixel_x(pixel_x_int),
    .pixel_y(pixel_y_int)
);


Ball_Logic ball_inst (
    .SLOW_CLOCK(slow_clock_sig),
    .RESET_N(KEY[0]),
    .KEY_RANDOM_PULSE(key_random_pulse_sig), 
    .BALL_X(ball_x_pos),
    .BALL_Y(ball_y_pos),
    .COLLISION_ACTIVE(collision_active_sig)
    
);


Color_Generator color_inst (
    .PIXEL_X(pixel_x_int),
    .PIXEL_Y(pixel_y_int),
    .video_on(video_on_sig),
    .BALL_X(ball_x_pos),
    .BALL_Y(ball_y_pos),
    .COLLISION_ACTIVE(collision_active_sig),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
);


assign divisor_val_sig = (SW[1:0] == 2'b00) ? 26'd5000000 :
                         (SW[1:0] == 2'b01) ? 26'd2500000 :
                         (SW[1:0] == 2'b10) ? 26'd1000000 :
                         26'd500000; 


reg key_random_d; 
wire key_press = ~KEY[1]; 


always @(posedge CLOCK_50 or negedge KEY[0]) begin
    if (!KEY[0]) 
        key_random_d <= 1'b0;
    else 
        key_random_d <= key_press;
end


assign key_random_pulse_sig = key_press && !key_random_d;

endmodule
