iverilog -g2012 -o tb_Top.out fixed_64_mult.v Top.v tb_Top.v
vvp tb_Top.out
gtkwave tb_Top.vcd