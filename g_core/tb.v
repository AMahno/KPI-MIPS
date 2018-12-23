`timescale 1ns/10ps
`include "proc.v"

module tb();
	reg tb_clk = 1'b0;
	reg tb_reset;
	proc proc_INST(.i_clk(tb_clk));
	
	always
		#5 tb_clk <= !tb_clk;
		
endmodule