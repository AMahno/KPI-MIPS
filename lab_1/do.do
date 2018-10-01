vsim -gui work.tb -t ns

restart
delete wave /*

add wave -radix hexadecimal /tb/mux_a
add wave -radix hexadecimal /tb/mux_b 
add wave /tb/mux_control
add wave -radix hexadecimal /tb/mux_out 

add wave /tb/sign_in
add wave /tb/sign_out
add wave /tb/unsign_tb

add wave -radix hexadecimal /tb/reg_w
add wave -radix hexadecimal /tb/addr_w
add wave -radix hexadecimal /tb/addr_a
add wave -radix hexadecimal /tb/addr_b
add wave -radix hexadecimal /tb/reg_out_a
add wave -radix hexadecimal /tb/reg_out_b
add wave -radix hexadecimal /tb/clk
add wave -radix hexadecimal /tb/we

add wave -radix hexadecimal /tb/in_shift
add wave -radix hexadecimal /tb/out_shift

add wave /tb/reset
add wave -radix hexadecimal /tb/load
add wave -radix hexadecimal /tb/pc_out

wave zoom range 0ns 650ns
run 650 ns
