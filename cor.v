module Color_Generator (
    input wire [9:0] PIXEL_X,      
    input wire [9:0] PIXEL_Y,       
    input wire video_on,            
    
    
    input wire [9:0] BALL_X,        
    input wire [9:0] BALL_Y,        
    input wire COLLISION_ACTIVE,    
    
    
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B
);


localparam BALL_SIZE = 8;
localparam BORDER_SIZE = 2; 
localparam X_MIN = 192;
localparam X_MAX = 447;
localparam Y_MIN = 112;
localparam Y_MAX = 367;


localparam C_BLACK  = 4'h0; 
localparam C_WHITE  = 4'hF; 
localparam C_BLUE   = 4'h8; 
localparam C_YELLOW = 4'hF; 
localparam C_RED    = 4'hF; 



always @* begin
    
   
    if (video_on == 0) begin
        VGA_R = C_BLACK;
        VGA_G = C_BLACK;
        VGA_B = C_BLACK;
        return; 
    end
    
    
    if ((PIXEL_X >= BALL_X) && (PIXEL_X < BALL_X + BALL_SIZE) &&
        (PIXEL_Y >= BALL_Y) && (PIXEL_Y < BALL_Y + BALL_SIZE)) 
    {
        VGA_R = C_WHITE;
        VGA_G = C_WHITE;
        VGA_B = C_WHITE;
    }
    
    else if (((PIXEL_X >= X_MIN) && (PIXEL_X < X_MIN + BORDER_SIZE)) || 
             ((PIXEL_X >= X_MAX - BORDER_SIZE + 1) && (PIXEL_X <= X_MAX)) || 
             ((PIXEL_Y >= Y_MIN) && (PIXEL_Y < Y_MIN + BORDER_SIZE)) || 
             ((PIXEL_Y >= Y_MAX - BORDER_SIZE + 1) && (PIXEL_Y <= Y_MAX))) 
    {
       
        if (COLLISION_ACTIVE) begin
            VGA_R = C_RED;
            VGA_G = C_BLACK;
            VGA_B = C_BLACK;
        end else begin
            VGA_R = C_BLACK;
            VGA_G = C_BLACK;
            VGA_B = C_BLUE;
        end
    }
    
    else begin
        VGA_R = C_BLACK;
        VGA_G = C_BLACK;
        VGA_B = C_BLACK;
    end
    
end
endmodule
