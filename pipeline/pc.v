module pc(i_clk, i_rst_n, i_pc, o_pc);

	input               i_clk, i_rst_n;
	input       [31:0]  i_pc;
	output  [31:0]  o_pc;
	
	reg [31:0] pc;
	assign o_pc = i_rst_n ? pc : 0;
	
	always @(posedge i_clk)
		pc <= i_pc;
   
endmodule