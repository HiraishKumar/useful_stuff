module func_grad_val_diff(
    input clk,
    input rst_n,
    input start_func,
    input signed [31:0] x_in,
    output reg signed [63:0] gradient,
    output reg signed [63:0] value,
    output reg signed [31:0] x_diff_out,
    output reg func_done,
    output reg overflow
);
    localparam TWO_H = 32'h00000002;            // Q24.8 2H = 7.8125e-3 in decimal 
    localparam LEARNING_RATE = 32'h00000080;    // Q24.8 0.5 in decimal
    wire signed [63:0]val1;                     // Q56.8
    wire signed [63:0]val2;                     // Q56.8
    wire signed [31:0] x_in_minus_2H;           // Q24.8
    wire signed [63:0] gradient_intermediate;   // Q56.8 
    wire signed [31:0] x_diff;                  // Q24.8
    wire func1_done;
    wire func2_done;
    wire mult_done;
    wire overflow1;
    wire overflow2;
    wire overflow_mult;
    wire underflow_mult;

    assign x_in_minus_2H = x_in - TWO_H;
    assign gradient_intermediate = (val1 - val2) << 7;

    func func_val(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in ),               // Q24.8
        .y_out(val1),               // Q56.8
        .func_done(func1_done),
        .overflow(overflow1)
    );

    func inst2(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in_minus_2H),       // Q24.8
        .y_out(val2),               // Q56.8 
        .func_done(func2_done),
        .overflow(overflow2)
    );

    fixed_32_mult inst_diff(
        .a_in(LEARNING_RATE),               // Q24.8
        .b_in(gradient_intermediate[31:0]), // Q24.8
        .p_out(x_diff),                     // Q56.8
        .overflow(overflow_mult),
        .underflow_q(underflow_mult)
    );

    wire all_funcs_done;
    assign all_funcs_done = func1_done & func2_done ;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            gradient    <= 64'd0;
            value       <= 64'd0;
            func_done   <= 1'b0;
            overflow    <= 1'b0;
        end else begin
            if (all_funcs_done) begin
                gradient <= gradient_intermediate;
                value <= val1;
                func_done <= 1'b1;
                overflow <= overflow1 | overflow2 | overflow_mult;
                if (overflow_mult) begin 
                    x_diff_out <= 32'h7FFFFFFF; // capped at Highest positive 32 bit signed value
                end else if (underflow_mult) begin
                    x_diff_out <= 32'h80000000; // capped at minimum negetive 32 bit signed value 
                end else begin
                    x_diff_out <= x_diff;
                end
            end else begin
                func_done <= 1'b0;
            end
        end
    end
endmodule