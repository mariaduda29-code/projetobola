module divisor
#(
	parameter NUM_BITS = 26
)
(
	input wire clock_in, reset_n, enable,
	output reg clock_out
	input wire [NUM_BITS - 1:0] divisor_value,
	output reg clock_out
);

  reg [NUM_BITS - 1:0] count;

  always@(posedge clock_in, negedge reset_n)
  begin
  	if(reset_n == 0)
  	begin
  		count <= 0;
  		clock_out <= 0;
  	end
  	else if(enable == 1)
  	begin
  		if (count == divisor_value - 1) begin
  			count <= 0;
  			clock_out <= ~clock_out; 
  		end else begin
  			count <= count + 1;
  		end
  	end
  end
  
endmodule
