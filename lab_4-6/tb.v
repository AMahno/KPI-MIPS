`timescale 1ns/10ps
`include "proc.v"

module tb();
	reg tb_clk = 1'b0;
	reg tb_reset;
	proc proc_INST(.clk(tb_clk), .reset(tb_reset));
	
	always
		#5 tb_clk <= !tb_clk;
		
	initial begin
		tb_reset <= 1'b0;
		tb_reset <= #10 1'b1;
	end
endmodule
