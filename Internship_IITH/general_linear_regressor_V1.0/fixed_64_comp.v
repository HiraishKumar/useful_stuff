module fixed_64_comp(
    input signed [63:0] a_in,  // signed Q56.8
    input signed [63:0] b_in,  // signed Q56.8
    output logic comp_result   // 1 if a_in < b_in, else 0
);
    assign comp_result = (a_in < b_in) ;
endmodule