module reg32(c, d, q);

	input               c;
	input       [31:0]  d;
	output  reg [31:0]  q;
	
	initial
		q <= 32'd0;
	
	always @(posedge c)
		q <= d;
   
endmodule