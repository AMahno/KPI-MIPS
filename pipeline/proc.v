`include "pc.v"
`include "rom.v"
`include "regFile.v"
`include "mux2in1.v"
`include "alu.v"
`include "signExtend.v"
`include "ram.v"
`include "control.v"
`include "aluControl.v"
`include "reg32.v"

module proc(clk, reset, allow_jump);
	input clk;
	input reset;
	input allow_jump;
	
	wire [31:0] rom_to_reg;
	
	wire [31:0] instruction;
	wire [5:0] op = instruction[31:26];
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];
	wire [5:0] func = instruction[5:0];
	wire [15:0] imm16 = instruction[15:0];
	wire [25:0] imm26 = instruction[25:0];
	
	wire regDst;
	wire jump;
	wire branch;
	wire memToReg;
	wire [1:0] aluOp;
	wire memWrite;
	wire aluSrc;
	wire regWrite;
	control control_INST(.i_instrCode(op), 
									 .o_regDst(regDst),
									 .o_jump(jump), 
									 .o_branch(branch),
									 .o_memToReg(memToReg),
									 .o_aluOp(aluOp),
									 .o_memWrite(memWrite),
									 .o_aluSrc(aluSrc),
									 .o_regWrite(regWrite));
	
	wire [4:0] write_addr;
	wire [31:0] bus_A_to_ALU;
	wire [31:0] bus_B_to_mux;
	wire [31:0] busW;
	wire [31:0] fw_A_to_ALU;
	wire [31:0] fw_B_to_ALU;
	wire [31:0] extend_to_mux;
	wire [31:0] mux_to_ALU;
	wire [3:0] alu_control;
	wire [31:0] ALU_result;
	wire [31:0] RAM_data;
	wire [31:0] ram_out;
	
	reg [1:0] fw_A;
	reg [1:0] fw_B;
	
	wire [15:0] imm_16_to_ext;
	wire [31:0] reg_to_alu_A;
	wire [31:0] reg_to_alu_B;
	wire [4:0] rd_2_to_3;
	
	wire [9:0] ex_reg_control;
	
	wire [31:0] res_reg_to_ram;
	wire [31:0] d_reg_to_ram;
	wire [4:0] rd_3_to_4;
	wire [4:0] rd_4_to_regfile;
	
	wire [5:0] mem_reg_control;
	wire wb_to_regWrite;
	
	wire zf;
	wire cmp_zf = fw_A_to_ALU == fw_B_to_ALU;
	
	wire [31:0] mux_to_pc;
	wire [31:0] npc_to_npc2;
	wire [31:0] npc2_to_block;
	wire [25:0] imm26_to_block;
	
	wire [31:0] pc_to_rom;
	
	wire [31:0] next_pc = pc_to_rom + 1;
	wire PCSrc = jump | (branch & cmp_zf);
	wire [31:0] jump_addr = jump ? ({pc_to_rom[31:26], imm26}) : (pc_to_rom + {{14{imm16[15]}}, imm16});
	
	reg ex_mux_ctl;
	wire crotch_pc_src = allow_jump ? PCSrc : 1'b0;
	
	mux2in1 pc_mux(.i_dat0(next_pc), .i_dat1(jump_addr), .i_control(crotch_pc_src), .o_dat(mux_to_pc));
	
	pc pc_INST(.i_clk(clk), .i_rst_n(reset), .i_pc(mux_to_pc), .o_pc(pc_to_rom));
	
	rom rom_INST(.i_addr(pc_to_rom[7:0]), .o_data(rom_to_reg));
	
	reg32 instruction_reg(.c(clk), .d(PCSrc ? 0 : rom_to_reg), .q(instruction));
	reg32 next_pc_reg(.c(clk), .d(next_pc), .q(npc_to_npc2));
	
	mux2in1 write_addr_mux(.i_dat0(rt), .i_dat1(rd), .i_control(regDst), .o_dat(write_addr));
	
	regFile regFile_INST(	.i_clk(clk), 
										.i_raddr1(rs), 
										.i_raddr2(rt), 
										.i_waddr(rd_4_to_regfile), 
										.i_wdata(busW), 
										.i_we(wb_to_regWrite),
										.o_rdata1(bus_A_to_ALU),
										.o_rdata2(bus_B_to_mux) 
									   );
	
	mux4in1 forward_A(.d0(bus_A_to_ALU), .d1(ALU_result), .d2(ram_out), .d3(busW), .s(fw_A), .out(fw_A_to_ALU));
	mux4in1 forward_B(.d0(bus_B_to_mux), .d1(ALU_result), .d2(ram_out), .d3(busW), .s(fw_B), .out(fw_B_to_ALU));
	
	reg32 npc2_reg(.c(clk), .d(npc_to_npc2), .q(npc2_to_block));
	reg32 imm26_reg(.c(clk), .d(imm26), .q(imm26_to_block));
	
	reg32 imm16_reg(.c(clk), .d(imm16), .q(imm_16_to_ext));
	reg32 A_reg(.c(clk), .d(fw_A_to_ALU), .q(reg_to_alu_A));
	reg32 B_reg(.c(clk), .d(fw_B_to_ALU), .q(reg_to_alu_B));
	reg32 rd2_reg(.c(clk), .d(write_addr), .q(rd_2_to_3));
	
	//reg32 ex_reg(.c(clk), .d({alu_control, memWrite, memToReg, jump, branch, regWrite, aluSrc}), .q(ex_reg_control));
	wire [9:0] ctl_signals = ex_mux_ctl==1 ? {aluSrc, regWrite, branch, jump, memToReg, memWrite, alu_control} : 0;
	reg32 ex_reg(.c(clk), .d(ctl_signals), .q(ex_reg_control));
	
	signExtend extend_INST(.i_data(imm_16_to_ext), .o_data(extend_to_mux), .unsign(1'b1));

	mux2in1 alu_mux(.i_dat0(reg_to_alu_B), .i_dat1(extend_to_mux), .i_control(ex_reg_control[9]), .o_dat(mux_to_ALU));	
	
	aluControl aluControl_INST(.i_aluOp(op), .i_func(func), .o_aluControl(alu_control));
	
	alu alu_INST(.i_op1(reg_to_alu_A), .i_op2(mux_to_ALU), .i_control(ex_reg_control[3:0]), .o_result(ALU_result), .o_zf(zf));
	
	reg32 result_reg(.c(clk), .d(ALU_result), .q(res_reg_to_ram));
	reg32 d_reg(.c(clk), .d(reg_to_alu_B), .q(d_reg_to_ram));
	reg32 rd3_reg(.c(clk), .d(rd_2_to_3), .q(rd_3_to_4));

	reg32 mem_reg(.c(clk), .d(ex_reg_control[8:4]), .q(mem_reg_control));
	
	ram ram_inst(.i_clk(clk), .i_addr(res_reg_to_ram), .i_data(d_reg_to_ram), .i_we(mem_reg_control[0]), .o_data(RAM_data));
	
	mux2in1 RAM_mux(.i_dat0(res_reg_to_ram), .i_dat1(RAM_data), .i_control(mem_reg_control[1]), .o_dat(ram_out));
	
	reg32 WData_reg(.c(clk), .d(ram_out), .q(busW));
	reg32 rd4_reg(.c(clk), .d(rd_3_to_4), .q(rd_4_to_regfile));
	reg32 wb_reg(.c(clk), .d(mem_reg_control[4]), .q(wb_to_regWrite));
	
	always @* begin
		if(rs != 0 & rs == rd_2_to_3[4:0] & ex_reg_control[8]) fw_A = 1;
		else
			if(rs != 0 & rs == rd_3_to_4[4:0] & mem_reg_control[4]) fw_A = 2;
			else
				if(rs != 0 & rs == rd_4_to_regfile[4:0] & wb_to_regWrite) fw_A = 3;
				else
					fw_A = 0;
					
		if(rt != 0 & rt == rd_2_to_3[4:0] & ex_reg_control[8]) fw_B = 1;
		else
			if(rt != 0 & rt == rd_3_to_4[4:0] & mem_reg_control[4]) fw_B = 2;
			else
				if(rt != 0 & rt == rd_4_to_regfile[4:0] & wb_to_regWrite) fw_B = 3;
				else
					fw_B = 0;
					
		if((ex_reg_control[5] & (fw_A == 1 | fw_B == 1)) | jump) ex_mux_ctl = 0;
		else ex_mux_ctl = 1;
	end
endmodule
