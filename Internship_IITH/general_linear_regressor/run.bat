iverilog -g2012 -o tb_Top.out func.v func_grad_val_diff.v fixed_64_comp.v fixed_64_mult.v fixed_32_mult.v Top.v tb_Top.v
vvp tb_Top.out
gtkwave tb_Top.vcd