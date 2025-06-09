module Top(
    input [31:0] x_in,
    output [31:0] y_out
);

    assign y_out = x_in * x_in + 32'd4 * x_in - 32'd1;
endmodule