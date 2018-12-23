module mux4in1(d0, d1, d2, d3, s, out);
	input [31:0] d0, d1, d2, d3;
	input [1:0] s;
	output reg [31:0] out;
	
	always @*
		case(s)
			2'd0: out = d0;
			2'd1: out = d1;
			2'd2: out = d2;
			2'd3: out = d3;
		endcase
endmodule