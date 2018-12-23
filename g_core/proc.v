`include "rom.v"
`include "ID.v"
`include "regFile.v"

module proc(i_clk);
	input i_clk;
	
	wire [15:0] rom_to_id;
	wire [15:0] file_to_rom;
	rom rom_inst(.i_addr(file_to_rom), .o_data(rom_to_id));
	
	wire [4:0] src, dst;
	wire lw, j, br, bq_blt;
	wire [15:0] imm;
	
	ID id_inst(	.i_instr(rom_to_id), 
					.o_src(src), .o_dst(dst), 
					.o_lw(lw), .o_j(j), .o_br(br), .o_bq_blt(bq_blt), 
					.o_imm(imm));
					
	regFile reqFile_inst(	.i_clk(i_clk),
								.i_src(src),
								.i_dst(dst),
								.i_lw(lw),
								.i_imm(imm),
								.i_j(j),
								.i_br(br),
								.i_bq_blt(bq_blt),
								.o_pc(file_to_rom));
endmodule
