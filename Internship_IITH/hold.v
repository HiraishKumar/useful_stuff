`include "fixed_32_mult.v"      // Assuming these are 32-bit fixed-point modules
`include "fixed_32_sub.v"       // Assuming these are 32-bit fixed-point modules
`include "gradient_func.v" // This module needs to compute ((x+h)^2 - (x-h)^2)/(2*h) using 32-bit fixed
`include "fixed_32_cmp.v"

////////////////////////////////////////////////////////////////////
//      #TODO
//          :Write 
//              // DONE fixed_32_mult 
//              // DONE fixed_32_add_sub
//              // DONE fixed_comp
//              ?? NOT NEEDED ?? fixed_div
//              // DONE gradient_func:
//                  Implement the function ((x+h)^2 - (x-h)^2)/(2*h) 
//                  Shortened to 2x 
////////////////////////////////////////////////////////////////////





module Top #(
    parameter NUM_ITERATIONS = 16,// Make num_iterations a parameter for flexibility
    parameter OFFSET = 32'h00040000  // offset of 4.0 from the y axis
) (
    input clk,
    input rst_n, // Active-low reset
    input start_op, // Start the gradient descent operation
    input [31:0] initial_x_in, // Renamed to avoid conflict with internal reg
    input [31:0] learning_rate_in, // Renamed to avoid conflict with internal reg
    output reg [31:0] x_at_min,
    output reg [31:0] y_min,
    output reg done_op // Signal when the operation is complete
);

    // Internal registers
    reg [31:0] x;

    reg [31:0] learning_rate_reg; // Register to hold learning_rate

    reg [$clog2(NUM_ITERATIONS+1)-1:0] iter_count; // Iteration counter

    // Wires for module outputs (combinational outputs of instances)
    wire comp_result;
    wire [31:0] gradient_out;
    wire [31:0] y_squared_out;
    wire [31:0] x_diff_out;
    wire [31:0] x_next_val;
    wire [31:0] initial_y_min_val;

    // State machine to control the gradient descent process
    localparam STATE_IDLE = 2'b00;
    localparam STATE_INIT = 2'b01;
    localparam STATE_RUNNING = 2'b10;
    localparam STATE_DONE = 2'b11;

    reg [1:0] current_state, next_state;

    // Combinational logic for determining next state
    always @(*) begin
        next_state = current_state; // Default to staying in current state
        case (current_state)
            STATE_IDLE: begin
                if (start_op)
                    next_state = STATE_INIT;
            end
            STATE_INIT: begin
                next_state = STATE_RUNNING;
            end
            STATE_RUNNING: begin
                if (iter_count == NUM_ITERATIONS)
                    next_state = STATE_DONE;
            end
            STATE_DONE: begin
                if (!start_op) // Allow reset by deasserting start_op
                    next_state = STATE_IDLE;
            end
        endcase
    end

    // Sequential logic (state transitions and register updates)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_IDLE;
            x <= 32'b0; // Reset to 0 or another suitable value
            y_min <= 32'b0;
            x_at_min <= 32'b0;
            learning_rate_reg <= 32'b0;
            iter_count <= 0;
            done_op <= 1'b0;
        end else begin
            current_state <= next_state; // Update state

            case (current_state)
                STATE_IDLE: begin
                    // DO NOTHING
                end
                STATE_INIT: begin
                    // Initialize values once at the start of operation
                    x <= initial_x_in;                    //
                    x_at_min <= initial_x_in;             // Load in the Value of inputs into internal reg
                    learning_rate_reg <= learning_rate_in;//
                    y_min <= initial_y_min_val;     // load initial y = x_inintial_in ** 2
                    iter_count <= 0;
                    done_op <= 1'b0;
                end
                STATE_RUNNING: begin
                    // increment iterator
                    iter_count <= iter_count + 1;

                    // 1. if result of comparison between y_squared_out(fixed) < y_min(fixed)
                    //  equals to 1 then values of results {y_min,x_at_min} are updated 

                    if (comp_result) begin      //Output 1 if y_squared_out < y_min
                        y_min <= y_squared_out;
                        x_at_min <= x;          // x_next_val is the x that resulted in y_squared_out
                    end
                    
                    // 2. Update x = x - x_diff
                    // inst_sub is already instantiated below, its output is x_next_val

                    x <= x_next_val;            // Update x for the next iteration
                end
                STATE_DONE: begin
                    done_op <= 1'b1;            // Signal that the operation is complete
                    // final value stored in reg y_min[31:0]
                end
            endcase
        end
    end


    // Calculate gradient
    gradient_func inst_grad (
        .x(x), // Use the current value of x
        .offset(OFFSET),
        .res(gradient_out) // Output of the gradient calculation
    );

    fixed_32_cmp cmp_fixed(
        .a(y_min),
        .b(y_squared_out),
        .res(comp_result)    // Output 1 if y_squared_out < y_min
    )

    // Calculate y = x^2
    fixed_32_mult inst_mult_y ( // Renamed for clarity
        .a(x), // Use the current value of x
        .b(x),
        .res(y_squared_out) // Output of x^2 calculation
    );

    // Calculate x_diff = learning_rate * gradient
    fixed_32_mult inst_mult_x_diff ( 
        .a(learning_rate_reg), 
        .b(gradient_out), //gradient out from gradient_func
        .res(x_diff_out) // Output = learning_rate * gradient
    );

    // calculate the inital value of y = initial_x_in**2
    fixed_32_mult inst_initial_x_square (
        .a(initial_x_in),
        .b(initial_x_in),
        .res(initial_y_min_val) // This wire will hold initial_x_in squared
    );

    // Calculate x = x - x_diff
    fixed_32_sub inst_sub_x ( 
        .a(x), 
        .b(x_diff_out),  // Use the combinational x_diff output
        .res(x_next_val) // Output of x - x_diff
    );

endmodule