iverilog -g2012 -o tb_Top.out fixed_32_add_sub.v fixed_56_cmp.v fixed_32_mult.v fixed_56_mult.v gradient_func.v Top.v tb_Top.v
vvp tb_Top.out
gtkwave tb_Top.vcd