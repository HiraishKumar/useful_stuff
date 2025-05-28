`timescale 1ns / 1ps

module FixedPointAddSub_tb;
    reg signed [31:0] a_in;
    reg signed [31:0] b_in;
    reg sub_n_add;
    wire signed [31:0] sum_diff_out;
    wire overflow;

    // Initialize Add Sub Module
    FixedPointAddSub uut(
        .a_in(a_in),
        .b_in(b_in),
        .sub_n_add(sub_n_add),
        .sum_diff_out(sum_diff_out),
        .overflow(overflow)
    );

    localparam integer SCALE_FACTOR = 1 << 16; // 2^16 = 65536 

    initial begin
        $dumpfile("FixedPointAddSub.vcd");
        $dumpvars(0, FixedPointAddSub_tb);

        // a = 2.0      hex = 0002.0000 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'h00020000;
        b_in = 32'h00030000;
        sub_n_add = 1'b0;
        #10;

        $display("----TEST CASE 1 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("Operation: %b", sub_n_add);
        $display("P_out: %f", $signed(sum_diff_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);


        // a = 4.36      hex = 0004.5C29 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'h00045C29;
        b_in = 32'h00030000;
        sub_n_add = 1'b1;

        #10;

        $display("----TEST CASE 2 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("Operation: %b", sub_n_add);
        $display("P_out: %f", $signed(sum_diff_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);


        // a = -2.0      hex = FFFE.0000 {in 2s complement}
        // b = 3.0      hex = 0003.0000 {in 2s complement}
        a_in = 32'hFFFE0000;
        b_in = 32'h00030000;
        sub_n_add = 1'b1;

        #10;

        $display("----TEST CASE 3 ----");
        $display("A_in: %f", $signed(a_in) / real'(SCALE_FACTOR));
        $display("B_in: %f", $signed(b_in) / real'(SCALE_FACTOR));
        $display("Operation: %b", sub_n_add);
        $display("P_out: %f", $signed(sum_diff_out) / real'(SCALE_FACTOR));
        $display("Overflow: %b", overflow);

        $finish;
    end
endmodule