module pc(i_clk, i_rst_n, i_pc, o_pc);

	input               i_clk, i_rst_n;
	input       [31:0]  i_pc;
	output  reg [31:0]  o_pc;
	
	always @(posedge i_clk)
		if (!i_rst_n)
			o_pc <= i_pc;
		else
			o_pc <= o_pc + 1;
   
endmodule