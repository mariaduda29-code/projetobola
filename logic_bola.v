module Ball_Logic (
    input wire SLOW_CLOCK,          
    input wire RESET_N,
    
    input wire [1:0] SW_VELOCITY,   
    input wire KEY_RANDOM_PULSE,   
    
   
    output reg [9:0] BALL_X,        
    output reg [9:0] BALL_Y,       
    
    
    output reg COLLISION_ACTIVE,    
    output reg [3:0] COLLISION_TIMER_OUT 
);


localparam BALL_SIZE = 8;
localparam BORDER_SIZE = 1;


localparam X_MIN = 192;
localparam X_MAX = 192 + 256 - 1; 


localparam Y_MIN = 112;
localparam Y_MAX = 112 + 256 - 1; 


localparam FLASH_DURATION = 10;


reg [9:0] dx; 
reg [9:0] dy; 
reg [3:0] collision_timer; 


reg [7:0] lfsr_reg; 

always @(posedge SLOW_CLOCK or negedge RESET_N) begin
    if (!RESET_N) begin
        lfsr_reg <= 8'h01; 
    end else begin
        
        lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[3] ^ lfsr_reg[2] ^ lfsr_reg[1]};
    end
end


always @(posedge SLOW_CLOCK or negedge RESET_N) begin
    if (!RESET_N) begin
        BALL_X <= X_MIN + 16;
        BALL_Y <= Y_MIN + 16;
        dx <= 1; 
        dy <= 1; 
        COLLISION_ACTIVE <= 0;
        collision_timer <= 0;
    end else begin
        
       
        reg x_collision = 0;
        reg y_collision = 0;
        
        
        if (BALL_X + dx >= X_MAX - BALL_SIZE + 1 - BORDER_SIZE) begin 
            dx <= -dx; 
            x_collision = 1;
        end
        
        if (BALL_X + dx <= X_MIN + BORDER_SIZE) begin
            dx <= -dx; 
            x_collision = 1;
        end

        
        if (BALL_Y + dy >= Y_MAX - BALL_SIZE + 1 - BORDER_SIZE) begin
            dy <= -dy; 
            y_collision = 1;
        end
        
        if (BALL_Y + dy <= Y_MIN + BORDER_SIZE) begin
            dy <= -dy; 
            y_collision = 1;
        end

        
        if (x_collision | y_collision) begin
            COLLISION_ACTIVE <= 1;
            collision_timer <= FLASH_DURATION; 
        end
        
        
        if (collision_timer > 0) begin
            collision_timer <= collision_timer - 1;
        end else begin
            COLLISION_ACTIVE <= 0; 
        end
        
        
        BALL_X <= BALL_X + dx;
        BALL_Y <= BALL_Y + dy;
        
        
        if (KEY_RANDOM_PULSE) begin
            if (lfsr_reg[0] == 1) begin
                dx <= -dx;
            end
            if (lfsr_reg[1] == 1) begin
                dy <= -dy;
            end
        end
        
    end
end

assign COLLISION_TIMER_OUT = collision_timer; 

endmodule
