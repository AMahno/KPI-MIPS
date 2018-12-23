module regFile(
			i_clk,
			i_src,
			i_dst,
			i_lw,
			i_imm,
			i_j,
			i_br,
			i_bq_blt,
			o_pc);
               
	input				i_clk, i_lw, i_j, i_br, i_bq_blt;
	input [4:0]   	i_src, i_dst;
	input [15:0] 	i_imm;
	output [15:0]	o_pc;

	localparam 	PC = 0, EQ_R = 1, MT_R = 2, ADD_R = 3, SUB_R = 4, OR_R = 5, AND_R = 6, NOT_R = 7, SL_R = 8, SR_R = 9,
						EQ_A = 10, EQ_B = 11, MT_A = 12, MT_B = 13, ADD_A = 14, ADD_B = 15, SUB_A = 16, SUB_B = 17, 
						OR_A = 18, OR_B = 19, AND_A = 20, AND_B = 21, NOT_A = 22, NOT_B = 23, 
						SL_A = 24, SL_Am = 25, SR_A = 26, SR_Am = 27, LW_REG = 28;
	
	reg [15:0] regs[31:0];
	
	wire [15:0] selected_src = regs[i_src];
	wire [15:0] dest_data = i_lw ? i_imm : selected_src;
	
	wire br_needed = i_bq_blt ? regs[EQ_R] : regs[MT_R];
	wire jbr = i_j | (i_br & br_needed);
	
	assign o_pc = regs[PC];
		
	always @(posedge i_clk) begin
		if(i_lw) regs[LW_REG] <= i_imm;
		else
			if(i_dst > 9)
				regs[i_dst] <= dest_data;
		
		regs[PC] <= jbr ? i_imm : regs[PC] + 1;
		
		regs[EQ_R] <= regs[EQ_A] == regs[EQ_B];
		regs[MT_R] <= regs[MT_A] > regs[MT_B];
		regs[ADD_R] <= regs[ADD_A] + regs[ADD_B];
		regs[SUB_R] <= regs[SUB_A] - regs[SUB_B];
		regs[OR_R] <= regs[OR_A] | regs[OR_B];
		regs[AND_R] <= regs[AND_A] & regs[AND_B];
		regs[NOT_R] <= ~ regs[NOT_A] | regs[NOT_B];
		regs[SL_R] <= regs[SL_A] << regs[SL_Am];
		regs[SR_R] <= regs[SR_R] >> regs[SR_Am];
	end

	initial
		regs[PC] <= 0;
	
endmodule