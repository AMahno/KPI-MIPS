vsim -gui work.tb -t ns

restart
delete wave /*

radix define opcode {
	6'h00 "R_FORMAT"
	6'h2b "SW"
	6'h23 "LW"
	6'h04 "BEQ"
	6'h02 "JUMP"
}


add wave -radix opcode /tb/tb_opcode
add wave  /tb/tb_regDst 
add wave  /tb/tb_jump 
add wave  /tb/tb_branch 
add wave  /tb/tb_memToReg 
add wave  /tb/tb_ALU_op 
add wave  /tb/tb_memWrite 
add wave  /tb/tb_ALUSrc 
add wave  /tb/tb_regWrite 

wave zoom range 0ns 70ns
run 70 ns
