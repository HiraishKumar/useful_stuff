module Top(
    input clk,
    input rst_n,
    input start_func,
    input signed [31:0] x_in, // Q24.8 format
    output reg signed [63:0] gradient, // Stores the final gradient (derived from Q56.8)
    output reg signed [63:0] value,    // Stores val1 (Q56.8)
    output reg signed [31:0] x_diff_out, // Q24.8 format
    output reg func_done,
    output reg overflow
);
    localparam signed [31:0] TWO_H = 32'h00000200; // 2.0 in Q24.8 
    localparam signed [31:0] LEARNING_RATE = 32'h00000080; // 0.5 in Q24.8 

    wire signed [63:0] val1; //Q56.8 output from 'func'
    wire signed [63:0] val2; //Q56.8 output from 'func'

    wire signed [31:0] x_in_minus_2H; // Q24.8 format
    wire signed [63:0] gradient_raw_q56_8; // (val1 - val2) in Q56.8
    wire signed [63:0] gradient_divided_by_h_q56_8; // gradient_raw / h (still Q56.8)
    wire signed [31:0] gradient_for_mult_q24_8; // Converted to Q24.8 for multiplier

    wire signed [31:0] x_diff; // Q24.8 from fixed_32_mult

    wire func1_done;
    wire func2_done;
    wire overflow1;
    wire overflow2;
    wire overflow_mult;
    wire underflow_mult;

    // Fixed-point subtraction (Q24.8 - Q24.8 = Q24.8)
    assign x_in_minus_2H = x_in - TWO_H;

    // Calculate raw difference of function values (Q56.8 - Q56.8 = Q56.8)
    assign gradient_raw_q56_8 = val1 - val2;

    // Divide by 'h' or (2.0) and then left shifted by 8 to land in the Q56.8 format
    assign gradient_divided_by_h_q56_8 = gradient_raw_q56_8 <<< 7;

    // Convert the gradient to Q24.8 for input to fixed_32_mult.
    assign gradient_for_mult_q24_8 = gradient_divided_by_h_q56_8[31:0];


    func func_val(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in),    // Q24.8
        .y_out(val1),   // Q56.8
        .func_done(func1_done),
        .overflow(overflow1)
    );

    func inst2(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in_minus_2H),   // Q24.8
        .y_out(val2),           // Q56.8
        .func_done(func2_done),
        .overflow(overflow2)
    );

    // fixed_32_mult takes Q24.8 inputs and produces Q24.8 output
    fixed_32_mult inst_diff(
        .a_in(LEARNING_RATE),           // Q24.8 
        .b_in(gradient_for_mult_q24_8), // Q24.8
        .p_out(x_diff),                 // Q24.8
        .overflow(overflow_mult),
        .underflow_q(underflow_mult)
    );

    wire all_funcs_done;
    assign all_funcs_done = func1_done & func2_done;

    // Internal register for func_done to be pulsed for one cycle
    reg func_done_internal;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            gradient <= 64'd0;
            value <= 64'd0;
            x_diff_out <= 32'd0;
            func_done_internal <= 1'b0;
            overflow <= 1'b0;
        end else begin
            // Reset func_done_internal if a new computation starts, or if we just finished a computation
            if (start_func) begin
                func_done_internal <= 1'b0;
            end else if (all_funcs_done && !func_done_internal) begin // Only set high for one cycle when all are done
                gradient <= gradient_divided_by_h_q56_8; // Store the Q56.8 gradient
                value <= val1; // Store the Q56.8 function value
                func_done_internal <= 1'b1; // Signal completion for one cycle
                overflow <= overflow1 | overflow2 | overflow_mult;

                if (overflow_mult) begin
                    x_diff_out <= 32'h7FFFFFFF; // capped at Highest positive 32 bit signed value
                end else if (underflow_mult) begin
                    x_diff_out <= 32'h80000000; // capped at minimum negative 32 bit signed value
                end else begin
                    x_diff_out <= x_diff;
                end
            end else begin
                // If not starting a new computation and not just finished, keep func_done_internal low
                func_done_internal <= 1'b0; // This handles cases where all_funcs_done might stay high
            end
        end
    end

    // Output func_done is a pulse
    assign func_done = func_done_internal;

endmodule