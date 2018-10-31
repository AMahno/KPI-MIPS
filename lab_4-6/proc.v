`include "pc.v"
`include "rom.v"
`include "regFile.v"
`include "mux2in1.v"
`include "alu.v"
`include "signExtend.v"
`include "ram.v"
`include "control.v"
`include "aluControl.v"

module proc(clk, reset);
	input clk;
	input reset;
	
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
	wire aluOp;
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
	
	wire zf;
	
	wire [29:0] pc_to_rom;
	wire [29:0] next_pc = pc_to_rom + 1;
	wire PCSrc = jump | (branch & zf) | (branch & ~zf);
	wire [29:0] jump_addr = jump ? ({next_pc[29:26], imm26}) : (next_pc + {14{imm16[15]}});
	wire [29:0] mux_to_pc;
	
	mux2in1 pc_mux(.i_dat0(next_pc), .i_dat1(jump_addr), .i_control(PCSrc), .o_dat(jump_addr));
	
	pc pc_INST(.i_clk(clk), .i_rst_n(reset), .i_pc(jump_addr), .o_pc(pc_to_rom));
	
	rom rom_INST(.i_addr(pc_to_rom), .o_data(instruction));
	
	wire [4:0] write_addr;
	mux2in1 write_addr_mux(.i_dat0(rt), .i_dat1(rd), .i_control(regDst), .o_dat(write_addr));
	
	wire [31:0] bus_A_to_ALU;
	wire [31:0] bus_B_to_mux;
	wire [31:0] busW;
	regFile regFile_INST(	.i_clk(clk), 
										.i_raddr1(rs), 
										.i_raddr2(rt), 
										.i_waddr(write_addr), 
										.i_wdata(busW), 
										.i_we(regWrite),
										.o_rdata1(bus_A_to_ALU),
										.o_rdata2(bus_B_to_mux) 
									   );
	
	wire [31:0] extend_to_mux;
	signExtend extend_INST(.i_data(imm16), .o_data(extend_to_mux), .unsign(1'b1));

	wire [31:0] mux_to_ALU;
	mux2in1 alu_mux(.i_dat0(bus_B_to_mux), .i_dat1(extend_to_mux), .i_control(aluSrc), .o_dat(mux_to_ALU));
	
	wire [3:0] alu_control;
	aluControl aluControl_INST(.i_aluOp(op), .i_func(func), .o_aluControl(alu_control));
	
	wire [31:0] ALU_result;
	alu alu_INST(.i_op1(bus_A_to_ALU), .i_op2(mux_to_ALU), .i_control(alu_control), .o_result(ALU_result), .o_zf(zf));
	
	wire [31:0] RAM_data;
	ram ram_inst(.i_clk(clk), .i_addr(ALU_result), .i_data(bus_B_to_mux), .i_we(memWrite), .o_data(RAM_data));
	
	mux2in1 RAM_mux(.i_dat0(ALU_result), .i_dat1(RAM_data), .i_control(memToReg), .o_dat(busW));
endmodule
