module func_grad_val_diff #(
    parameter LEARNING_RATE = 32'h00000020 // Parameter for the learning rate
)(
    input clk,            // Clock input
    input rst_n,          // Asynchronous active-low reset
    input start_func,     // Control signal to start function computation
    input signed [31:0] x_in, // Input value for the function (Q24.8 fixed-point format)
    output reg signed [63:0] gradient, // Output: Computed gradient (Q56.8 fixed-point format)
    output reg signed [63:0] value,    // Output: Function value f(x_in) (Q56.8 fixed-point format)
    output reg signed [31:0] x_diff_out, // Output: Change in x (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg func_done,  // Output: Indicates when all function computations are complete
    output reg overflow    // Output: Indicates an overflow occurred during any computation
);

    // Local parameter for 2H, used in gradient approximation
    localparam TWO_H = 32'h00000002; // Q24.8 fixed-point format (decimal 7.8125e-3 if Q0.31, but here Q24.8 means 2 / 2^8 = 2/256)

    // Wires for the outputs of the two 'func' instances
    wire signed [63:0] y_out1_func; // Output of the first function (f(x_in))
    wire signed [63:0] y_out2_func; // Output of the second function (f(x_in - 2H))

    // Registers to store the stable, completed outputs from the 'func' modules.
    // This is crucial to ensure gradient calculation uses valid data after reset/start.
    reg signed [63:0] val1_reg; // Stores the completed f(x_in)
    reg signed [63:0] val2_reg; // Stores the completed f(x_in - 2H)

    // Wire for the input to the second 'func' instance
    wire signed [31:0] x_in_minus_2H;

    // Wire for the calculated gradient before outputting
    wire signed [63:0] gradient_calc;

    // Wire for the output of the multiplier (change in x)
    wire signed [31:0] x_diff;

    // Wires for 'func' module completion signals
    wire func1_done;
    wire func2_done;

    // Wires for overflow/underflow signals from 'func' and 'fixed_32_mult' modules
    wire overflow1;
    wire overflow2;
    wire overflow_mult;
    wire underflow_mult;

    // Calculate x_in - 2H for the second function evaluation
    assign x_in_minus_2H = x_in - TWO_H;

    // Instantiate the first 'func' module to calculate f(x_in)
    func func_val(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in),                     // Input x (Q24.8)
        .y_out(y_out1_func),             // Output f(x) (Q56.8)
        .func_done(func1_done),          // Completion signal for this function
        .overflow(overflow1)             // Overflow signal for this function
    );

    // Instantiate the second 'func' module to calculate f(x_in - 2H)
    func inst2(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in_minus_2H),           // Input x - 2H (Q24.8)
        .y_out(y_out2_func),            // Output f(x - 2H) (Q56.8)
        .func_done(func2_done),         // Completion signal for this function
        .overflow(overflow2)            // Overflow signal for this function
    );

    // Register the outputs of the 'func' modules when they complete their computation.
    // This ensures 'gradient_calc' uses valid, stable values and not intermediate or reset values.
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            val1_reg <= 64'd0; // Reset registered value
            val2_reg <= 64'd0; // Reset registered value
        end else begin
            if (func1_done) begin
                val1_reg <= y_out1_func; // Capture f(x_in) when its computation is done
            end
            if (func2_done) begin
                val2_reg <= y_out2_func; // Capture f(x_in - 2H) when its computation is done
            end
        end
    end

    // Calculate the gradient using the registered and stable function values.
    // The shift by 7 is equivalent to dividing by 2H (which is 2^-7 or 1/128 for Q24.8)
    // (val1 - val2) / (2H) = (val1 - val2) / (2 * (2^-8)) = (val1 - val2) / (2^-7) = (val1 - val2) * 2^7
    assign gradient_calc = (val1_reg - val2_reg) << 7; // Result is Q56.8

    // Instantiate the fixed-point multiplier for LEARNING_RATE * gradient
    // Note: gradient_calc (Q56.8) is truncated to its lower 32 bits (Q24.8) before multiplication,
    // as implied by the original design's connection (gradient_intermediate[31:0]).
    fixed_32_mult inst_diff(
        .a_in(LEARNING_RATE),                   // Multiplicand A (Q24.8)
        .b_in(gradient_calc[31:0]),             // Multiplicand B (Q24.8, truncated from gradient_calc)
        .p_out(x_diff),                         // Product P (Q24.8)
        .overflow(overflow_mult),               // Overflow from multiplier
        .underflow_q(underflow_mult)            // Underflow from multiplier
    );

    // Wire to check if both function computations are complete
    wire all_funcs_done;
    assign all_funcs_done = func1_done & func2_done;

    // Sequential logic to update outputs based on computation completion
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            // Reset all output registers
            gradient    <= 64'd0;
            value       <= 64'd0;
            x_diff_out  <= 32'd0;
            func_done   <= 1'b0;
            overflow    <= 1'b0;
        end else begin
            // If both function computations are complete
            if (all_funcs_done) begin
                gradient  <= gradient_calc; // Assign the computed gradient
                value     <= y_out1_func;   // Assign the value of f(x_in)
                func_done <= 1'b1;          // Assert done signal
                // Combine all overflow signals
                overflow  <= overflow1 | overflow2 | overflow_mult;

                // Handle overflow/underflow for x_diff_out, capping at max/min signed 32-bit values
                if (overflow_mult) begin
                    x_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                end else if (underflow_mult) begin
                    x_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                end else begin
                    x_diff_out <= x_diff;      // Assign the valid computed x_diff
                end
            end else begin
                func_done <= 1'b0; // Deassert done signal if computations are ongoing
                // Outputs (gradient, value, x_diff_out, overflow) retain their last values
                // until a new computation is complete or a reset occurs.
            end
        end
    end

endmodule