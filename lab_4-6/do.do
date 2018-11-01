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

add wave /tb/tb_clk
add wave /tb/tb_reset
add wave -radix hexadecimal sim:/tb/proc_INST/*

wave zoom range 0ns 150ns
run 150 ns
