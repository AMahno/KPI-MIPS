vsim -gui work.tb -t ns

restart
delete wave /*

radix define control_out {
	4'b0010 "ADD"
	4'b0110 "SUB"
	4'b0000 "AND"
	4'b0001 "OR"
	4'b0111 "SOLT"
	4'b1100 "NOR"
}

radix define control_in {
	2'b00 "LWSW"
	2'b01 "BE"
	2'b10 "RTYPE"
}


add wave -radix control_in /tb/tb_aluOp
add wave  /tb/tb_func 
add wave -radix control_out /tb/tb_aluControl

add wave /tb/clk
add wave /tb/tb_we
add wave -radix hexadecimal /tb/tb_ram_addr
add wave -radix hexadecimal /tb/tb_ram_in_data
add wave -radix hexadecimal /tb/tb_ram_out_data

add wave -radix hexadecimal /tb/tb_a
add wave -radix hexadecimal /tb/tb_b
add wave -radix hexadecimal /tb/tb_result

add wave -radix control_out /tb/tb_alu_control_a
add wave -radix hexadecimal /tb/tb_alu_result
add wave /tb/tb_zero

add wave -radix hexadecimal /tb/tb_rom_addr
add wave -radix hexadecimal /tb/tb_rom_data

wave zoom range 0ns 1000ns
run 1000 ns
