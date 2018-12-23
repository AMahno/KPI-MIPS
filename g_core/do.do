vsim -gui work.tb -t ns

restart
delete wave /*

add wave /tb/tb_clk
add wave -radix hexadecimal sim:/tb/proc_INST/reqFile_inst/*

wave zoom range 0ns 150ns
