module Top #(
    NUM_ITERATIONS = 50,
    LEARNING_RATE = 32'h0000_0030,       // Decimal 0.125 Q24.8 format
    CONVERGENCE_THRESHOLD = 16'h0100     // 1.0 in Q8.8 format (256 in decimal)
) (
    input clk,
    input rst_n,
    input start_op,
    input signed [15:0] a_init,         // Q8.8 format
    input signed [15:0] b_init,         // Q8.8 format
    input signed [15:0] c_init,         // Q8.8 format
    input signed [15:0] d_init,         // Q8.8 format
    output reg signed [31:0] z_min,     // Q24.8 format
    output reg signed [15:0] a_at_min,     // Q8.8 format
    output reg signed [15:0] b_at_min,     // Q8.8 format
    output reg signed [15:0] c_at_min,     // Q8.8 format
    output reg signed [15:0] d_at_min,     // Q8.8 format
    output reg done_op,
    output reg converged                // New output to indicate convergence
);

    // INTERNAL VARIABLE REG
    reg signed [15:0] a_in;     // Q8.8 format
    reg signed [15:0] b_in;     // Q8.8 format
    reg signed [15:0] c_in;     // Q8.8 format
    reg signed [15:0] d_in;     // Q8.8 format

    reg [$clog2(NUM_ITERATIONS + 1)-1 : 0] iter_count;

    reg func_reset;     
    reg start_func;      

    reg signed [31:0] z_min_inter;

    reg signed [15:0] a_at_min_inter;
    reg signed [15:0] b_at_min_inter;
    reg signed [15:0] c_at_min_inter;
    reg signed [15:0] d_at_min_inter;

    // REGISTERS TO HOLD STATE
    reg [2:0] current_state;
    reg [2:0] next_state;

    // CONVERGENCE LOGIC REGISTERS
    reg convergence_check;
    reg step_size_converged;

    // INTERNAL WIREs
    wire func_done;
    wire comp_result;

    wire [15:0] a_next_val;
    wire [15:0] b_next_val;
    wire [15:0] c_next_val;
    wire [15:0] d_next_val;

    wire [31:0] z_out;

    wire [15:0] a_diff_out;
    wire [15:0] b_diff_out;
    wire [15:0] c_diff_out;
    wire [15:0] d_diff_out;

    // CONVERGENCE CHECK WIRES
    wire [15:0] abs_a_diff, abs_b_diff, abs_c_diff, abs_d_diff;
    wire a_converged, b_converged, c_converged, d_converged;

    // STATE DEFINITION
    localparam IDLE         = 3'b000;
    localparam INIT         = 3'b001;
    localparam CALL_FUNC    = 3'b010; 
    localparam CMP_STR      = 3'b011; // COMPARE AND STORE
    localparam CHECK_CONV   = 3'b100; // CHECK CONVERGENCE
    localparam DONE         = 3'b101;
        
    always @(*) begin 
        next_state = current_state;
        case (current_state)
            IDLE : begin 
                if (start_op) next_state = INIT;
            end
            INIT : begin 
                next_state = CALL_FUNC;
            end
            CALL_FUNC : begin 
                if (func_done) next_state = CMP_STR;
            end
            CMP_STR : begin
                next_state = CHECK_CONV;
            end
            CHECK_CONV : begin
                if (iter_count == NUM_ITERATIONS || step_size_converged) begin
                    next_state = DONE;
                end else begin 
                    next_state = CALL_FUNC;
                end
            end
            DONE : begin 
                if (!start_op) next_state = IDLE;
            end
        endcase
    end

    // Absolute value calculations for convergence check
    assign abs_a_diff = (a_diff_out[15]) ? (~a_diff_out + 1'b1) : a_diff_out;
    assign abs_b_diff = (b_diff_out[15]) ? (~b_diff_out + 1'b1) : b_diff_out;
    assign abs_c_diff = (c_diff_out[15]) ? (~c_diff_out + 1'b1) : c_diff_out;
    assign abs_d_diff = (d_diff_out[15]) ? (~d_diff_out + 1'b1) : d_diff_out;

    // Individual parameter convergence checks
    assign a_converged = (abs_a_diff < CONVERGENCE_THRESHOLD);
    assign b_converged = (abs_b_diff < CONVERGENCE_THRESHOLD);
    assign c_converged = (abs_c_diff < CONVERGENCE_THRESHOLD);
    assign d_converged = (abs_d_diff < CONVERGENCE_THRESHOLD);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            current_state <= IDLE;
            a_in <= 16'd0;
            b_in <= 16'd0;
            c_in <= 16'd0;
            d_in <= 16'd0;

            a_at_min <= 16'd0;
            b_at_min <= 16'd0;
            c_at_min <= 16'd0;
            d_at_min <= 16'd0;

            a_at_min_inter <= 16'd0;
            b_at_min_inter <= 16'd0;
            c_at_min_inter <= 16'd0;
            d_at_min_inter <= 16'd0;

            z_min       <= 32'h7FFFFFFF;
            z_min_inter <= 32'h7FFFFFFF;

            func_reset  <= 1'b0;        // Active Low Reset
            iter_count  <= 0;
            done_op     <= 1'b0;
            converged   <= 1'b0;
            convergence_check <= 1'b0;
            step_size_converged <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE : begin 
                    // DO NOTHING
                    done_op <= 1'b0;
                    converged <= 1'b0;
                    convergence_check <= 1'b0;
                    step_size_converged <= 1'b0;
                    func_reset <= 1'b1; // Disassert Reset Of func
                end
                INIT : begin 
                    a_in <= a_init;
                    b_in <= b_init;
                    c_in <= c_init;
                    d_in <= d_init;

                    a_at_min <= a_init;
                    b_at_min <= b_init;
                    c_at_min <= c_init;
                    d_at_min <= d_init;

                    a_at_min_inter <= a_init;
                    b_at_min_inter <= b_init;
                    c_at_min_inter <= c_init;
                    d_at_min_inter <= d_init;

                    z_min<= 32'h7FFFFFFF;
                    z_min_inter <= 32'h7FFFFFFF;

                    start_func <= 1'b1;    // assert Start
                    iter_count <= 0;
                    convergence_check <= 1'b0;
                    step_size_converged <= 1'b0;
                end
                CALL_FUNC : begin 
                    if (func_done) begin
                        iter_count <= iter_count + 1;

                        z_min_inter <= z_out;

                        a_at_min_inter <= a_in;
                        b_at_min_inter <= b_in;
                        c_at_min_inter <= c_in;
                        d_at_min_inter <= d_in;
                        
                        start_func <= 1'b0;    // Disassert Start
                        convergence_check <= 1'b1; // Enable convergence check
                    end 
                end
                CMP_STR : begin
                    if (comp_result) begin
                        z_min <= z_min_inter;
                        a_at_min <= a_at_min_inter; 
                        b_at_min <= b_at_min_inter; 
                        c_at_min <= c_at_min_inter; 
                        d_at_min <= d_at_min_inter; 
                    end
                    a_in <= a_next_val;
                    b_in <= b_next_val;
                    c_in <= c_next_val;
                    d_in <= d_next_val;

                    start_func <= 1'b1;     // assert Start
                end
                CHECK_CONV : begin
                    // Check if all step sizes are below threshold
                    if (convergence_check && a_converged && b_converged && c_converged && d_converged) begin
                        step_size_converged <= 1'b1;
                        converged <= 1'b1;
                    end
                    convergence_check <= 1'b0;
                end
                DONE : begin 
                    done_op <= 1'b1;
                    func_reset <= 1'b0;    // Assert Reset
                end
            endcase
        end
    end

    // MODULE CALLS

    // Outputs the Gradient, value & Step size of 'function under test' at x_in 
    func_grad_val_diff #(
        .LEARNING_RATE(LEARNING_RATE)
    ) grad_val_diff (
        .clk(clk),
        .rst_n(func_reset),
        .start_func(start_func),
        .a_in(a_in),          // 16 bit Q8.8 format
        .b_in(b_in),          // 16 bit Q8.8 format
        .c_in(c_in),          // 16 bit Q8.8 format
        .d_in(d_in),          // 16 bit Q8.8 format
        .value(z_out),
        .a_diff_out(a_diff_out),
        .b_diff_out(b_diff_out),
        .c_diff_out(c_diff_out),
        .d_diff_out(d_diff_out),
        .func_done(func_done), 
        .overflow()
    );

    fixed_32_comp compare(
        .a_in(z_min_inter),
        .b_in(z_min),
        .comp_result(comp_result)   // output 1 if z_min_inter < z_min
    );

    fixed_16_capped_diff a_next(
        .a_in(a_in),
        .b_in(a_diff_out),
        .next_val(a_next_val),
        .overflow(),
        .underflow_q()
    );

    fixed_16_capped_diff b_next(
        .a_in(b_in),
        .b_in(b_diff_out),
        .next_val(b_next_val),
        .overflow(),
        .underflow_q()
    );

    fixed_16_capped_diff c_next(
        .a_in(c_in),
        .b_in(c_diff_out),
        .next_val(c_next_val),
        .overflow(),
        .underflow_q()
    );

    fixed_16_capped_diff d_next(
        .a_in(d_in),
        .b_in(d_diff_out),
        .next_val(d_next_val),
        .overflow(),
        .underflow_q()
    );

endmodule