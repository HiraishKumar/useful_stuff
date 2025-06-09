module func_grad_val_diff #(
    parameter LEARNING_RATE = 32'h00000020 // Parameter for the learning rate
)(
    input clk,            
    input rst_n,
    input start_func,     
    input signed [31:0] x_in, //(Q24.8 fixed-point format)
    output reg signed [63:0] gradient, //(Q56.8 fixed-point format)
    output reg signed [63:0] value,    //(Q56.8 fixed-point format)
    output reg signed [31:0] x_diff_out, // Change in x (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg func_done,  
    output reg overflow    
);

    localparam TWO_H = 32'h00000002; // Q24.8 fixed-point format (decimal 7.8125e-3 if Q0.31, but here Q24.8 means 2 / 2^8 = 2/256)
    localparam GRADatZERO = 32'h00000400;  // Gradeint of the function at zero (where it is after reset)
    wire signed [63:0] y_out1_func; // Output of the first function (f(x_in))
    wire signed [63:0] y_out2_func; // Output of the second function (f(x_in - 2H))

    reg signed [63:0] val1_reg; // Stores the completed f(x_in)
    reg signed [63:0] val2_reg; // Stores the completed f(x_in - 2H)

    wire signed [31:0] x_in_minus_2H;
    wire signed [63:0] gradient_calc;
    wire signed [31:0] x_diff;
    wire func1_done;
    wire func2_done;
    wire overflow1;
    wire overflow2;
    wire overflow_mult;
    wire underflow_mult;

    assign x_in_minus_2H = x_in - TWO_H;

    func func_val(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in),                     // Input x (Q24.8)
        .y_out(y_out1_func),             // Output f(x) (Q56.8)
        .func_done(func1_done),          // Completion 
        .overflow(overflow1)             // Overflow 
    );

    func inst2(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_in_minus_2H),           // Input x - 2H (Q24.8)
        .y_out(y_out2_func),            // Output f(x - 2H) (Q56.8)
        .func_done(func2_done),         // Completion 
        .overflow(overflow2)            // Overflow 
    );

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

    assign gradient_calc = (val1_reg - val2_reg) << 7; // Result is Q56.8

    fixed_32_mult inst_diff(
        .a_in(LEARNING_RATE),                   // Multiplicand A (Q24.8)
        .b_in(gradient_calc[31:0]),             // Multiplicand B (Q24.8, truncated from gradient_calc)
        .p_out(x_diff),                         // Product P (Q24.8)
        .overflow(overflow_mult),               // Overflow from multiplier
        .underflow_q(underflow_mult)            // Underflow from multiplier
    );

    wire all_funcs_done;
    assign all_funcs_done = func1_done & func2_done;
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
                overflow  <= overflow1 | overflow2 | overflow_mult;

                if (overflow_mult) begin
                    x_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                end else if (underflow_mult) begin
                    x_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                end else begin
                    x_diff_out <= x_diff;      // Assign the valid computed x_diff
                end
            end else begin
                func_done <= 1'b0; 
            end
        end
    end

endmodule