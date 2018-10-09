module aluControl(i_aluOp, i_func, o_aluControl);
 
	input       [1:0]   i_aluOp;
	input       [5:0]   i_func;
	output  reg [3:0]   o_aluControl;
	
	localparam LWSW = 2'b00, BE = 2'b01, RTYPE = 2'b10;
	localparam ADD = 4'b0010, SUB = 4'b0110, AND = 4'b0000, OR = 4'b0001, SOLT = 4'b0111;
	
	always @(i_aluOp, i_func) begin
		case(i_aluOp)
			LWSW: o_aluControl = ADD;
			BE: o_aluControl = SUB;
			RTYPE:
				case(i_func)
					6'b100000: o_aluControl = ADD;
					6'b100010: o_aluControl = SUB;
					6'b100100: o_aluControl = AND;
					6'b100101: o_aluControl = OR;
					6'b101010: o_aluControl = SOLT;
					default: o_aluControl = 4'b0000;
				endcase
			default: o_aluControl = 4'b0000;
		endcase
	end
  
endmodule