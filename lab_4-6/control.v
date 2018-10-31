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
output 			o_regDst;
output 			o_jump; 
output 			o_branch;
output 			o_memToReg;
output  [1:0] 	o_aluOp;
output 			o_memWrite;
output 			o_aluSrc;
output 			o_regWrite;

	// Is memRead needed? Is jump and branch correct?

	wire rtype, sw, lw, beq, j;
	assign rtype = ~| i_instrCode;
	assign sw = i_instrCode == 6'h2b;
	assign lw = i_instrCode == 6'h23;
	assign beq = i_instrCode == 6'h04;
	assign j = i_instrCode == 6'h02;
	
	assign o_regDst = rtype;
	assign o_jump = j;
	assign o_branch = beq;
	assign o_memToReg = lw;
	assign o_aluOp[0] = ~rtype & ~lw & ~sw & beq;
	assign o_aluOp[1] = rtype & ~lw & ~sw & ~beq;
	assign o_memWrite = sw;
	assign o_aluSrc = ~(rtype | beq);
	assign o_regWrite = ~(sw | beq | j);
	
  
endmodule