module fixed_32_cmp(
    input signed [31:0]a,
    input signed [31:0]b,
    output logic res    // Output 1 if b > a
);
    assign res = b > a;
endmodule
