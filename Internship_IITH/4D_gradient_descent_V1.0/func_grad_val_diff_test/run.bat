iverilog -g2012 -o Top_tb.out fixed_32_add_sub.v fixed_32_mult.v fixed_32_capped_mult.v func.v  Top.v Top_tb.v
vvp Top_tb.out
gtkwave tb_Top.vcd