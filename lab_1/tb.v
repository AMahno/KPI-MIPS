`timescale 1ns/10ps
`include "mux2in1.v"
`include "signExtend.v"
`include "regFile.v"
`include "shiftLeftBy2.v"
`include "pc.v"

module tb();
	
	reg [31:0] mux_a;
	reg [31:0] mux_b;
	reg mux_control;
	wire [31:0] mux_out;
	
	mux2in1 mux(.i_dat0(mux_a), .i_dat1(mux_b), .i_control(mux_control), .o_dat(mux_out));
	
	reg [15:0] sign_in;
	wire [31:0] sign_out ;
	
	signExtend sign(.i_data(sign_in), .o_data(sign_out));
	
	reg [31:0] in_shift;
	wire [31:0] out_shift;
	
	shiftLeftBy2 shift(.i_data(in_shift), .o_data(out_shift));
	
	reg [31:0] reg_w;
	wire [31:0] reg_out_a;
	wire [31:0] reg_out_b;
	
	reg [4:0] addr_a;
	reg [4:0] addr_b;
	reg [4:0] addr_w;
	
	reg clk = 1'b0;
	reg we = 1'b0;
	
	integer i = 0;
	
	reg reset;
	reg [31:0] load;
	wire [31:0] pc_out;
	
	pc pc_inst(.i_clk(clk), .i_rst_n(reset), .i_pc(load), .o_pc(pc_out));
	
	regFile regfile_inst(.i_clk(clk), 
               .i_raddr1(addr_a), 
               .i_raddr2(addr_b), 
               .i_waddr(addr_w), 
               .i_wdata(reg_w), 
               .i_we(we),
               .o_rdata1(reg_out_a),
               .o_rdata2(reg_out_b) 
               );
	
		always
		#5 clk <= !clk;
	
	initial begin
		mux_a <= 32'hDEADBEEF;
		mux_b <= 32'hFEEDC0DE;
		mux_control <= 1'b0;
		mux_control <= #10 1'b1;
		
		sign_in <= 32'h3EEF;
		sign_in <= #10 32'hDEAD;
		
		in_shift <= 32'h1010;
		
		#5;
		load <= 0;
		reset <=1'b0;
		#5;
		reset <= 1'b1;
		
		we <= 1'b1;
		reg_w <= 32'hDEADBEEF;
		
		for(i = 0; i<32; i = i+1)
			begin
				addr_w = i;
				#10;
			end

		we <= 1'b0;
		load <= 32'hFEEDC0DE;
		reset <=1'b0;
		#10;
		reset <= 1'b1;
		
		for(i = 0; i<31; i = i+1)
			begin
				addr_a = i;
				addr_b = i+1;
				#10;
			end
		
	end

	
endmodule
