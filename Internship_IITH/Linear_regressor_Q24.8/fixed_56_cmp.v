module fixed_56_cmp(
    input signed [55:0]a,
    input signed [55:0]b,
    output logic res    // Output 1 if b > a
);
    assign res = b > a;
endmodule
