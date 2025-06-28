iverilog -g2012 -o Top_tb.out Top.v Top_tb.v
vvp Top_tb.out
gtkwave Top_tb.vcd