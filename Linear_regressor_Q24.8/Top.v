
module Top #(
    parameter NUM_ITERATIONS = 16,
    parameter OFFSET = 32'h00000400,        // Offset of 4 from Y axis
    parameter LEARNING_RATE = 32'h00000080  // Learning Rate of 0.5
) (
    input clk,
    input rst_n,                            // Active Low reset
    input start_op,                         // Level Dtected Operation Start 
    input signed [31:0] initial_x_in,       // Initial X
    output reg signed [31:0] x_at_min,      // X at minimum value of function
    output reg signed [31:0] y_min,         // Minimum Values of fucntion
    output reg done_op,                      // Flag to signal Completion of operation
    // FOR DEBUGGING
    output reg signed [31:0] learning_rate_out   // Outputs the value of learning rate 
);

// Internal register Declaration
reg signed [31:0] x;
reg [$clog2(NUM_ITERATIONS + 1) -1 : 0] iter_count;

// Register to hold current and next state

reg [1:0] current_state;
reg [1:0] next_state;

// Internal Wire Declaration

wire comp_result;
wire signed [31:0] gradient_out;
wire signed [31:0] x_squared_out;
wire signed [31:0] x_diff_out;
wire signed [31:0] x_next_val;
wire signed [31:0] initial_y_min_val;
wire signed [31:0] x_minus_offset;
wire signed [31:0] initial_x_minus_offset;
// State Machine State declaration

localparam STATE_IDLE     = 2'b00;
localparam STATE_INIT     = 2'b01;
localparam STATE_RUNNING  = 2'b10;
localparam STATE_DONE     = 2'b11;

always @(*) begin
    next_state = current_state;
    case (current_state)
        STATE_IDLE: begin                   // IF start_op is Set - Start Operation.
            if (start_op)
                next_state = STATE_INIT;
        end
        STATE_INIT: begin                   // Start RUNNING after INIT
            next_state = STATE_RUNNING;
        end
        STATE_RUNNING: begin                    // KEEP RUNNING iterations unto NUM_ITERATIONS
            if ( iter_count == NUM_ITERATIONS)  // Upon reaching NUM_ITERATIONS Move to DONE
                next_state = STATE_DONE;
        end
        STATE_DONE: begin                   // IF start_op is UN-SET 
            if (!start_op)
                next_state = STATE_IDLE;
        end 
    endcase
end


//           STATE_IDLE---------( start_op == 1)--------->STATE_INIT
//               ^           MOVE TO IDLE WHENEVER            |
//          (start_op == 0 )   start_op is UNSET              |
//               |                                            v    
//           STATE_DONE<---(iter_count == NUM_ITERATIONS)---STATE_RUNNING <----
//                                                            |               |
//                                                            L > (iter_count < NUM_ITERATIONS)

 always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        // When RESET is LOW defauly Values are loaded into the register
        current_state <= STATE_IDLE;    
        x <= 32'b0;
        y_min <= 32'd0;
        x_at_min <= 32'd0;
        learning_rate_out <= LEARNING_RATE;
        iter_count <= 0;
        done_op <= 1'b0;
    end else begin
        current_state <= next_state;
        case (current_state)
            STATE_IDLE : begin
                // DO NOTHING
                done_op <= 1'b0;
            end
            STATE_INIT : begin
                x <= initial_x_in;           // Initialize x
                y_min <= initial_y_min_val;  // Initialize y_min
                x_at_min <= initial_x_in;    // Initialize x_at_min
                iter_count <= 0;
                
            end
            STATE_RUNNING : begin
                iter_count <= iter_count + 1;

                if (comp_result) begin
                    y_min <= x_squared_out;
                    x_at_min <= x;
                end

                x <= x_next_val;
            end
            STATE_DONE : begin
                done_op <= 1'b1;
            end
        endcase
    end
 end

// ALL CALCULATIONS ARE DONE IN FIXED POINT Q24.8 FORMAT

// Calculate gradient
    gradient_func inst_grad (
        .x(x), // Use the current value of x
        .offset(OFFSET),
        .res(gradient_out) // Output of the gradient calculation
    );

    fixed_32_cmp cmp_fixed(
        .a(x_squared_out),
        .b(y_min),
        .res(comp_result)    // Output 1 if y_min > x_squared_out 
    );

    fixed_32_add_sub inst_x_minus_offset(
        .a_in(x),
        .b_in(OFFSET),
        .sub_n_add(1'b1),
        .sum_diff_out(x_minus_offset),
        .overflow()
    );

        // Calculate y = (x-OFFSET)^2
    fixed_32_mult inst_mult_y (
        .a_in(x_minus_offset),
        .b_in(x_minus_offset),
        .p_out(x_squared_out),
        .overflow()
    );

    // Calculate x_diff = learning_rate * gradient
    fixed_32_mult inst_mult_x_diff ( 
        .a_in(learning_rate_out), 
        .b_in(gradient_out), //gradient out from gradient_func
        .p_out(x_diff_out), // Output = learning_rate * gradient
        .overflow()
    );

    fixed_32_add_sub inst_initial_x_minus_offset(
        .a_in(initial_x_in),
        .b_in(OFFSET),
        .sub_n_add(1'b1),
        .sum_diff_out(initial_x_minus_offset),
        .overflow()
    );
    
    // Fix the initial square calculation:
    fixed_32_mult inst_initial_x_square (
        .a_in(initial_x_minus_offset),    // Use (initial_x_in - OFFSET)
        .b_in(initial_x_minus_offset),    // instead of just initial_x_in
        .p_out(initial_y_min_val),
        .overflow()
    );

    // Calculate x = x - x_diff
    fixed_32_add_sub inst_sub_x ( 
        .a_in(x), 
        .b_in(x_diff_out),  // Use the combinational x_diff output
        .sub_n_add(1'b1), // Set to subtract
        .sum_diff_out(x_next_val), // Output of x - x_diff
        .overflow()
    );
endmodule