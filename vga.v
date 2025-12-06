module vga_sync( 
  input wire CLOCK_50, 
  input wire RESET_N, 
  output reg hsync, 
  output reg vsync,
  output wire video_on, 
  output reg [9:0] pixel_x, 
  output reg [9:0] pixel_y 
);
  
localparam H_VISIBLE=640, H_FRONT=16, H_SYNC=96, H_BACK=48, H_TOTAL=800;
localparam V_VISIBLE=480, V_FRONT=10, V_SYNC=2, V_BACK=33, V_TOTAL=525;
reg [9:0] h_count, v_count;
  always @(posedge CLOCK_50 or posedge RESET_N)
    if (!RESET_N) begin 
      h_count<=0;
      v_count<=0; 
    end
    else if (h_count==H_TOTAL-1) begin
    h_count<=0;
    v_count <= (v_count==V_TOTAL-1)?0:v_count+1;
end else begin
    h_count<=h_count+1;
end
  
  always @(posedge CLOCK_50 or posedge RESET_N) begin
    if (!RESET_N) begin 
      pixel_x<=0; 
      pixel_y<=0; 
    end
    else begin pixel_x<=h_count; pixel_y<=v_count; 
    end
  end
  
always @* begin
    hsync = ~((h_count>=H_VISIBLE+H_FRONT) &&
              (h_count<H_VISIBLE+H_FRONT+H_SYNC));
    vsync = ~((v_count>=V_VISIBLE+V_FRONT) &&
              (v_count<V_VISIBLE+V_FRONT+V_SYNC));
end
  
assign video_on = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);
endmodule
