module func_grad_val_diff #(
    parameter LEARNING_RATE = 32'h00000020 // Q24.8 Parameter for the learning rate
)(
    input clk,            
    input rst_n,
    input start_func,     
    input signed [15:0] a_in,           //(Q8.8 fixed-point format)
    input signed [15:0] b_in,           //(Q8.8 fixed-point format)
    input signed [15:0] c_in,           //(Q8.8 fixed-point format)
    input signed [15:0] d_in,           //(Q8.8 fixed-point format)
    output reg signed [31:0] value,     //(Q26.8 fixed-point format)
    output reg signed [31:0] a_diff_out, // Change in a (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg signed [31:0] b_diff_out, // Change in b (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg signed [31:0] c_diff_out, // Change in c (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg signed [31:0] d_diff_out, // Change in d (LEARNING_RATE * gradient) (Q24.8 fixed-point format)
    output reg func_done,  
    output reg overflow    
);

    localparam TWO_H = 16'h0002; // Q24.8 fixed-point format (decimal 7.8125e-3 if Q0.31, but here Q24.8 means 2 / 2^8 = 2/256)

    // localparam GRADatZERO = 32'h00000400;  // Gradeint of the function at zero (where it is after reset)

    // CONTROL
    reg start_grad_func;
    reg rst_n_grad_func;
    reg [2:0] curr_state; 
    reg [2:0] next_state; 

    wire signed [31:0] z_val; // Output of the primary function (f(a_in, b_in, c_in, d_in ))

    wire signed [31:0] z_limit_a; // limit of function at (f(a_in - 2h, b_in, c_in, d_in))
    wire signed [31:0] z_limit_b; // limit of function at (f(a_in, b_in - 2h, c_in, d_in))
    wire signed [31:0] z_limit_c; // limit of function at (f(a_in, b_in, c_in - 2h, d_in))
    wire signed [31:0] z_limit_d; // limit of function at (f(a_in, b_in, c_in, d_in - 2h))

    reg signed [15:0] a_in_limit; // limiting values of inputs
    reg signed [15:0] b_in_limit; // limiting values of inputs
    reg signed [15:0] c_in_limit; // limiting values of inputs
    reg signed [15:0] d_in_limit; // limiting values of inputs

    wire signed [15:0] a_in_lim_wire; // limiting values of inputs
    wire signed [15:0] b_in_lim_wire; // limiting values of inputs
    wire signed [15:0] c_in_lim_wire; // limiting values of inputs
    wire signed [15:0] d_in_lim_wire; // limiting values of inputs

    reg signed [15:0] a_in_buffer;
    reg signed [15:0] b_in_buffer;
    reg signed [15:0] c_in_buffer;
    reg signed [15:0] d_in_buffer;

    wire signed [31:0] a_grad_wire;
    wire signed [31:0] b_grad_wire;
    wire signed [31:0] c_grad_wire;
    wire signed [31:0] d_grad_wire;

    reg signed [31:0] a_grad;
    reg signed [31:0] b_grad;
    reg signed [31:0] c_grad;
    reg signed [31:0] d_grad;
    
    wire signed [31:0] a_diff;
    wire signed [31:0] b_diff;
    wire signed [31:0] c_diff;
    wire signed [31:0] d_diff;

    wire func_val_done;
    wire func_a_grad_done;
    wire func_b_grad_done;
    wire func_c_grad_done;
    wire func_d_grad_done;
    wire all_func_done;

    wire func_val_overflow;
    wire func_a_grad_overflow;
    wire func_b_grad_overflow;
    wire func_c_grad_overflow;
    wire func_d_grad_overflow;

    wire overflow_mult_a, underflow_mult_a;
    wire overflow_mult_b, underflow_mult_b;
    wire overflow_mult_c, underflow_mult_c;
    wire overflow_mult_d, underflow_mult_d;

    wire overflow1;
    wire overflow2;
    wire overflow_mult;
    wire underflow_mult;


    // STAGE 1 - buffer inputs into a_in, b_in, c_in, d_in 
    //         - a_in_limit, b_in_limit, c_in_limit, d_in_limit 
    // STAGE 2 - calculate a_grad, b_grad, c_grad, d_grad
    // STAGE 3 - calculate a_diff, b_diff, c_diff, d_diff
    // STAGE 4 - register a_diff, b_diff, c_diff, d_diff in a_diff_out, b_diff_out, c_diff_out, d_diff_out
    //         - RAISE func_done


    localparam IDLE         = 3'b000;
    localparam INIT         = 3'b001;
    localparam CALL_FUNC    = 3'b010;
    localparam COMP_GRAD    = 3'b011;
    localparam COMP_DIFF    = 3'b100;
    localparam DONE         = 3'b101;

    always @(*) begin
        next_state = curr_state;
        case (curr_state)
            IDLE        : begin if (start_func)  next_state = INIT; end
            INIT        : begin next_state = CALL_FUNC; end
            CALL_FUNC   : begin if (all_func_done) next_state = COMP_GRAD; end
            COMP_GRAD   : begin next_state = COMP_DIFF; end
            COMP_DIFF   : begin next_state = DONE; end
            DONE        : begin if (!start_func) next_state = IDLE; end
            default     : begin next_state = IDLE; end
        endcase
        a_in_lim_wire = a_in - TWO_H;
        b_in_lim_wire = b_in - TWO_H;
        c_in_lim_wire = c_in - TWO_H;
        d_in_lim_wire = d_in - TWO_H;

        a_grad_wire = (z_val - z_limit_a) <<< 7;
        b_grad_wire = (z_val - z_limit_b) <<< 7;
        c_grad_wire = (z_val - z_limit_c) <<< 7;
        d_grad_wire = (z_val - z_limit_d) <<< 7;

        all_func_done = func_val_done & func_a_grad_done & func_b_grad_done & func_c_grad_done & func_d_grad_done;
        overflow = func_val_overflow | func_a_grad_overflow | func_b_grad_overflow | func_c_grad_overflow | func_d_grad_overflow;
    end

    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n) begin
            curr_state <= IDLE;

            func_done <= 1'b0;
            overflow <= 1'b0;

            start_grad_func <= 1'b0; // Halt Func operation
            rst_n_grad_func <= 1'b0; // reset funcs

            a_in_buffer <= 16'd0;
            b_in_buffer <= 16'd0;
            c_in_buffer <= 16'd0;
            d_in_buffer <= 16'd0;

            a_in_limit <= 16'd0;
            b_in_limit <= 16'd0;
            c_in_limit <= 16'd0;
            d_in_limit <= 16'd0;

            a_grad <= 32'd0;
            b_grad <= 32'd0;
            c_grad <= 32'd0;
            d_grad <= 32'd0;
            
            a_diff_out <= 0;
            b_diff_out <= 0;
            c_diff_out <= 0;
            d_diff_out <= 0;

            value <= 32'h0;
        end else begin
            curr_state <= next_state;
            case (curr_state)
                IDLE: begin 
                    // DO NOTHING
                    func_done <= 1'b0; 
                end
                INIT: begin     
                    a_in_buffer <= a_in;
                    b_in_buffer <= b_in;
                    c_in_buffer <= c_in;
                    d_in_buffer <= d_in;

                    a_in_limit <= a_in_lim_wire;
                    b_in_limit <= b_in_lim_wire;
                    c_in_limit <= c_in_lim_wire;
                    d_in_limit <= d_in_lim_wire;

                    start_grad_func <= 1'b0;    // Disassert Start
                    rst_n_grad_func <= 1'b0;    // Assert Reset
                end
                CALL_FUNC: begin
                    start_grad_func <= 1'b1;    // Assert Start
                    rst_n_grad_func <= 1'b1;    // Disassert Reset
                end             

                COMP_GRAD: begin
                    a_grad <= a_grad_wire;
                    b_grad <= b_grad_wire;
                    c_grad <= c_grad_wire;
                    d_grad <= d_grad_wire;
                end     

                COMP_DIFF: begin
                    if (overflow_mult_a) begin
                        a_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                    end else if (underflow_mult_a) begin
                        a_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                    end else begin
                        a_diff_out <= a_diff;      // Assign the valid computed a_diff
                    end

                    // Capping logic for b_diff_out
                    if (overflow_mult_b) begin
                        b_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                    end else if (underflow_mult_b) begin
                        b_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                    end else begin
                        b_diff_out <= b_diff;
                    end

                    // Capping logic for c_diff_out
                    if (overflow_mult_c) begin
                        c_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                    end else if (underflow_mult_c) begin
                        c_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                    end else begin
                        c_diff_out <= c_diff;
                    end

                    // Capping logic for d_diff_out
                    if (overflow_mult_d) begin
                        d_diff_out <= 32'h7FFFFFFF; // Capped at highest positive 32-bit signed value
                    end else if (underflow_mult_d) begin
                        d_diff_out <= 32'h80000000; // Capped at minimum negative 32-bit signed value
                    end else begin
                        d_diff_out <= d_diff;
                    end
                end             
                DONE: begin
                    // Computation of Stage 4 registered   
                    value <= z_val;
                    func_done <= 1'b1;
                end    
                default : begin
                    curr_state <= IDLE;
                    func_done <= 1'b0;
                    start_grad_func <= 1'b0;
                    rst_n_grad_func <= 1'b0;
                end         
            endcase
        end
    end

    fixed_32_mult calc_a_diff(       // Calculate a_grad * LEARNING RATE
        .a_in(a_grad),                    
        .b_in(LEARNING_RATE),                    
        .p_out(a_diff),       // Wire Output registed at next clock edge for the next stage
        .overflow(overflow_mult_a),
        .underflow_q(underflow_mult_a)
    );
    fixed_32_mult calc_b_diff(       // Calculate b_grad * LEARNING RATE
        .a_in(b_grad),                    
        .b_in(LEARNING_RATE),                    
        .p_out(b_diff),       // Wire Output registed at next clock edge for the next stage
        .overflow(overflow_mult_b),
        .underflow_q(underflow_mult_b)
    );
    fixed_32_mult calc_c_diff(       // Calculate c_grad * LEARNING RATE
        .a_in(c_grad),                    
        .b_in(LEARNING_RATE),                    
        .p_out(c_diff),       // Wire Output registed at next clock edge for the next stage
        .overflow(overflow_mult_c),
        .underflow_q(underflow_mult_c)
    );
    fixed_32_mult calc_d_diff(       // Calculate d_grad * LEARNING RATE
        .a_in(d_grad),                    
        .b_in(LEARNING_RATE),                    
        .p_out(d_diff),       // Wire Output registed at next clock edge for the next stage
        .overflow(overflow_mult_d),
        .underflow_q(underflow_mult_d)
    );


    func func_val(
        .clk(clk),
        .rst_n(rst_n_grad_func),
        .start_func(start_grad_func),
        .a_in(a_in_buffer), // 16 bit Q8.8 foramt
        .b_in(b_in_buffer), // 16 bit Q8.8 foramt
        .c_in(c_in_buffer), // 16 bit Q8.8 foramt
        .d_in(d_in_buffer), // 16 bit Q8.8 foramt
        .z_out(z_val),         // 32 bit Q24.8 foramt
        .func_done(func_val_done), 
        .overflow(func_val_overflow)
    );

    func func_a_grad (
        .clk(clk),
        .rst_n(rst_n_grad_func),
        .start_func(start_grad_func),
        .a_in(a_in_limit), // 16 bit Q8.8 foramt
        .b_in(b_in_buffer), // 16 bit Q8.8 foramt
        .c_in(c_in_buffer), // 16 bit Q8.8 foramt
        .d_in(d_in_buffer), // 16 bit Q8.8 foramt
        .z_out(z_limit_a),      // 32 bit Q24.8 foramt
        .func_done(func_a_grad_done), 
        .overflow(func_a_grad_overflow)
    );

    func func_b_grad (
        .clk(clk),
        .rst_n(rst_n_grad_func),
        .start_func(start_grad_func),
        .a_in(a_in_buffer), // 16 bit Q8.8 foramt
        .b_in(b_in_limit), // 16 bit Q8.8 foramt
        .c_in(c_in_buffer), // 16 bit Q8.8 foramt
        .d_in(d_in_buffer), // 16 bit Q8.8 foramt
        .z_out(z_limit_b),      // 32 bit Q24.8 foramt
        .func_done(func_b_grad_done), 
        .overflow(func_b_grad_overflow)
    );

    func func_c_grad (
        .clk(clk),
        .rst_n(rst_n_grad_func),
        .start_func(start_grad_func),
        .a_in(a_in_buffer), // 16 bit Q8.8 foramt
        .b_in(b_in_buffer), // 16 bit Q8.8 foramt
        .c_in(c_in_limit), // 16 bit Q8.8 foramt
        .d_in(d_in_buffer), // 16 bit Q8.8 foramt
        .z_out(z_limit_c),      // 32 bit Q24.8 foramt
        .func_done(func_c_grad_done), 
        .overflow(func_c_grad_overflow)
    );

    func func_d_grad (
        .clk(clk),
        .rst_n(rst_n_grad_func),
        .start_func(start_grad_func),
        .a_in(a_in_buffer), // 16 bit Q8.8 foramt
        .b_in(b_in_buffer), // 16 bit Q8.8 foramt
        .c_in(c_in_buffer), // 16 bit Q8.8 foramt
        .d_in(d_in_limit),  // 16 bit Q8.8 foramt
        .z_out(z_limit_d),      // 32 bit Q24.8 foramt
        .func_done(func_d_grad_done), 
        .overflow(func_d_grad_overflow)
    );

endmodule

