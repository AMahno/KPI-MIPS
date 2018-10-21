`include "control.v"

module tb();
	reg [5:0] tb_opcode;
	wire tb_regDst;
	wire tb_jump;
	wire tb_branch;
	wire tb_memToReg;
	wire [1:0] tb_ALU_op;
	wire tb_memWrite;
	wire tb_ALUSrc;
	wire tb_regWrite;
	
	control control_INST(.i_instrCode(tb_opcode), 
               .o_regDst(tb_regDst),
               .o_jump(tb_jump), 
               .o_branch(tb_branch),
               .o_memToReg(tb_memToReg),
               .o_aluOp(tb_ALU_op),
               .o_memWrite(tb_memWrite),
               .o_aluSrc(tb_ALUSrc),
               .o_regWrite(tb_regWrite)
               );
			   
	initial begin
		tb_opcode <= 0;
		tb_opcode <= #10 6'h2b;
		tb_opcode <= #20 6'h23;
		tb_opcode <= #30 6'h04;
		tb_opcode <= #40 6'h02;
		tb_opcode <= #50 6'hff;
	end
endmodule
