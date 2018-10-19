`timescale 1ns/10ps
`include "aluControl.v"
`include "ram.v"
`include "adder.v"
`include "alu.v"

module tb();
	
	reg [1:0] tb_aluOp;
	reg [5:0] tb_func;
	wire [3:0] tb_aluControl;
	
	aluControl aluControl_INST(.i_aluOp(tb_aluOp), .i_func(tb_func), .o_aluControl(tb_aluControl));
	localparam LWSW = 2'b00, BE = 2'b01, RTYPE = 2'b10;
	integer i;
	
	reg clk = 1'b0;
	reg [4:0] tb_ram_addr;
	reg [31:0] tb_ram_in_data;
	reg tb_we = 1'b0;
	wire [31:0] tb_ram_out_data;
	
	always
		#5 clk <= !clk;
	
	ram ram_INST(.i_clk(clk), .i_addr(tb_ram_addr), 
	.i_data(tb_ram_in_data), .i_we(tb_we), .o_data(tb_ram_out_data));
	
	reg [31:0] tb_a;
	reg [31:0] tb_b;
	wire [31:0] tb_result;
	
	adder adder_INST(.i_op1(tb_a), .i_op2(tb_b), .o_result(tb_result));
	
	reg [3:0] tb_alu_control_a;
	wire [31:0] tb_alu_result;
	wire tb_zero;
	localparam AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010;
	localparam SUB = 4'b0110, SOLT = 4'b0111, NOR = 4'b1100;
	alu alu_INST(.i_op1(tb_a), .i_op2(tb_b), .i_control(tb_alu_control_a),
	.o_result(tb_alu_result), .o_zf(tb_zero));
	
	reg [7:0] tb_rom_addr;
	wire [31:0] tb_rom_data;
	rom rom_INST(.i_addr(tb_rom_addr), .o_data(tb_rom_data));
	
	initial begin
		tb_aluOp <= LWSW;
		tb_aluOp <= #10 BE;
		tb_aluOp <= #20 RTYPE;
		
		#20;
		for(i = 0; i<5; i = i + 1) begin
			case(i)
				0: tb_func <= 6'b100000;
				1: tb_func <= 6'b100010;
				2: tb_func <= 6'b100100;
				3: tb_func <= 6'b100101;
				4: tb_func <= 6'b101010;
			endcase
			#10;
		end
		
		tb_we <= 1'b1;
		tb_ram_in_data <= 32'hDEADBEEF;
		
		for(i = 0; i<32; i = i+1)
			begin
				tb_ram_addr = i;
				#10;
			end
			
		tb_we <= 1'b0;
		for(i = 0; i<31; i = i+1)
			begin
				tb_ram_addr = i;
				#10;
			end
		
		tb_a <= 32'hDEADBEEF;
		tb_b <= 32'hFEEDC0DE;
		
		for(i = 0; i<6; i = i + 1) begin
			case(i)
				0: tb_alu_control_a <= AND;
				1: tb_alu_control_a <= OR;
				2: tb_alu_control_a <= ADD;
				3: tb_alu_control_a <= SUB;
				4: tb_alu_control_a <= SOLT;
				5: tb_alu_control_a <= NOR;
			endcase
			#10;
		end
		
		for(i = 0; i<256; i = i+1) begin
			tb_rom_addr <= i;
			#5;
		end
		
	end

endmodule
