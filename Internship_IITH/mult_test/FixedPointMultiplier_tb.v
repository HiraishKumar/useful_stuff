`timescale 1ns / 1ps

module FixedPointMultiplier_tb;

    reg signed [31:0] a_in;
    reg signed [31:0] b_in;
    wire signed [31:0] p_out;
    wire overflow;

    FixedPointMultiplier uut(
        .a_in(a_in),
        .b_in(b_in),
        .p_out(p_out),
        .overflow(overflow)
    );

    localparam integer SCALE_FACTOR = 1 << 16; // 2^16 = 65536
    initial begin

        $dumpfile("FixedPointMultiplier.vcd");
        $dumpvars(0, FixedPointMultiplier_tb);

        // a = 2.0      hex = 0002.0000 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'h00020000;
        b_in = 32'h00030000;
        #10;

        $display("----TEST CASE 1 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("P_out: %f", $signed(p_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);


        // a = 0.0      hex = 0000.0000 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'h00000000;
        b_in = 32'h00030000;
        #10;

        $display("----TEST CASE 2 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("P_out: %f", $signed(p_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);


        // a = -2.0      hex = FFFE.0000 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'hFFFE0000;
        b_in = 32'h00030000;
        #10;

        $display("----TEST CASE 3 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("P_out: %f", $signed(p_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);

        $finish;
    end

    
endmodule




