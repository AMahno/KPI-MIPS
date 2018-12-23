`timescale 1ns/10ps
`include "proc.v"

module tb();
	reg tb_clk = 1'b0;
	reg tb_reset;
	reg tb_allow;
	proc proc_INST(.clk(tb_clk), .reset(tb_reset), .allow_jump(tb_allow));
	
	always
		#5 tb_clk <= !tb_clk;
		
	initial begin
		tb_reset <= 1'b0;
		tb_allow <= 1'b0;
		tb_reset <= #10 1'b1;
		tb_allow <= #35 1'b1;
	end
endmodule
