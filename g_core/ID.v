module ID(i_instr, o_src, o_dst, o_lw, o_j, o_br, o_bq_blt, o_imm);
	input 	[15:0] i_instr;
	output 	[4:0] o_src, o_dst; 
	output reg	o_lw, o_j, o_br, o_bq_blt;
	output	[15:0] o_imm;
	
	wire [3:0] op = i_instr[3:0];
	assign o_src = i_instr[8:4];
	assign o_dst = i_instr[13:9];
	assign o_imm = i_instr[15:4];
	
	localparam mov = 4'd0, lw = 4'd1, j = 4'd2, beq = 4'd3, blt = 4'd4;
	
	always @ *
		case(op)
			mov:
				begin
					o_lw = 1'b0;
					o_j = 1'b0;
					o_br = 1'b0;
					o_bq_blt = 1'b0;
				end
			lw:
				begin
					o_lw = 1'b1;
					o_j = 1'b0;
					o_br = 1'b0;
					o_bq_blt = 1'b0;
				end
			j:
				begin
					o_lw = 1'b0;
					o_j = 1'b1;
					o_br = 1'b0;
					o_bq_blt = 1'b0;
				end
			beq:
				begin
					o_lw = 1'b0;
					o_j = 1'b0;
					o_br = 1'b1;
					o_bq_blt = 1'b1;
				end
			blt:
				begin
					o_lw = 1'b0;
					o_j = 1'b0;
					o_br = 1'b1;
					o_bq_blt = 1'b0;
				end
		endcase
endmodule
