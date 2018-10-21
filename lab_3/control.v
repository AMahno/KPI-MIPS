module control(i_instrCode, 
               o_regDst,
               o_jump, 
               o_branch,
               o_memToReg,
               o_aluOp,
               o_memWrite,
               o_aluSrc,
               o_regWrite
               );
  
input     [5:0]  i_instrCode;
output reg 			o_regDst;
output reg 			o_jump; 
output reg           o_branch;
output reg           o_memToReg;
output reg [1:0] 	o_aluOp;
output reg			o_memWrite;
output reg			o_aluSrc;
output reg			o_regWrite;

	localparam R_FORMAT = 6'h0, SW = 6'h2b, LW = 6'h23, BEQ = 6'h04, JUMP = 6'h02;
	// Is MemRead signal needed?
	always @(i_instrCode)
		case (i_instrCode)
			R_FORMAT: begin
				o_regDst 		= 1'b1;
				o_jump 			= 1'b0;
				o_branch			= 1'b0;
				o_memToReg 	= 1'b0;
				o_aluOp[0]		= 1'b0;
				o_aluOp[1]		= 1'b1;
				o_memWrite	= 1'b0;
				o_aluSrc			= 1'b0;
				o_regWrite		= 1'b1;
			end
			LW: begin
				o_regDst 		= 1'b0;
				o_jump 			= 1'b0;
				o_branch			= 1'b0;
				o_memToReg 	= 1'b1;
				o_aluOp[0]		= 1'b0;
				o_aluOp[1]		= 1'b0;
				o_memWrite	= 1'b0;
				o_aluSrc			= 1'b1;
				o_regWrite		= 1'b1;
			end
			SW: begin
				o_regDst 		= 1'bx;
				o_jump 			= 1'b0;
				o_branch			= 1'b0;
				o_memToReg 	= 1'bx;
				o_aluOp[0]		= 1'b0;
				o_aluOp[1]		= 1'b0;
				o_memWrite	= 1'b1;
				o_aluSrc			= 1'b1;
				o_regWrite		= 1'b0;
			end
			BEQ: begin
				o_regDst 		= 1'bx;
				o_jump 			= 1'b0;
				o_branch			= 1'b1;
				o_memToReg 	= 1'bx;
				o_aluOp[0]		= 1'b1;
				o_aluOp[1]		= 1'b0;
				o_memWrite	= 1'b0;
				o_aluSrc			= 1'b0;
				o_regWrite		= 1'b0;
			end
			JUMP: begin
				o_regDst 		= 1'bx;
				o_jump 			= 1'b1;
				o_branch			= 1'bx;
				o_memToReg 	= 1'bx;
				o_aluOp[0]		= 1'bx;
				o_aluOp[1]		= 1'bx;
				o_memWrite	= 1'bx;
				o_aluSrc			= 1'bx;
				o_regWrite		= 1'bx;
			end
			default: begin
				o_regDst 		= 1'bx;
				o_jump 			= 1'bx;
				o_branch			= 1'bx;
				o_memToReg 	= 1'bx;
				o_aluOp[0]		= 1'bx;
				o_aluOp[1]		= 1'bx;
				o_memWrite	= 1'bx;
				o_aluSrc			= 1'bx;
				o_regWrite		= 1'bx;
			end
		endcase
  
endmodule