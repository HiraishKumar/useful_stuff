iverilog -g2012 -o Top_tb.out fixed_128_mult.v fixed_128_add.v Top.v Top_tb.v
vvp Top_tb.out
@REM gtkwave Top_tb.vcd