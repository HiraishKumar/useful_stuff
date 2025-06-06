module Linear_regressor #(
    NUM_ITERATIONS = 10,
    LEARNING_RATE = 32'h00000080
) (
    input clk,
    input rst_n,
    input start_op,
    input signed [31:0] x_init,
    output reg signed [31:0] x_at_min,
    output reg signed [63:0] y_min,
    output reg done_op
);

    // INTERNAL VARIABLE REG
    reg signed [31:0] x_in;      // Q24.8 format
    reg [$clog2(NUM_ITERATIONS + 1)-1 : 0] iter_count;
    reg func_reset;      
    reg start_func_pulse; // Changed from start_func to start_func_pulse
    reg signed [31:0] x_at_min_inter;
    reg signed [63:0] y_min_inter;

    // REGISTERS TO HOLD STATE
    reg [2:0] current_state;
    reg [2:0] next_state;

    // INTERNAL WIREs
    wire func_done;
    wire comp_result;
    wire [31:0] x_next_val;
    wire [63:0] y_out;

    // STATE DEFINITION
    localparam STATE_IDLE = 3'b000;
    localparam STATE_INIT = 3'b001;
    localparam STATE_CALL_FUNC = 3'b010; 
    localparam STATE_CMP_STR = 3'b011; // COMPARE AND STORE
    localparam STATE_DONE = 3'b100;
        
    always @(*) begin 
        next_state = current_state;
        case (current_state)
            STATE_IDLE : begin 
                if (start_op) next_state = STATE_INIT;
            end
            STATE_INIT : begin 
                next_state = STATE_CALL_FUNC;
            end
            STATE_CALL_FUNC : begin 
                if (func_done) next_state = STATE_CMP_STR;
            end
            STATE_CMP_STR : begin
                if (iter_count == NUM_ITERATIONS) begin
                    next_state = STATE_DONE;
                end else begin 
                    next_state = STATE_CALL_FUNC;
                end
            end
            STATE_DONE : begin 
                if (!start_op) next_state = STATE_IDLE;
            end
        endcase
    end

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            current_state <= STATE_IDLE;
            x_in <= 32'd0;
            x_at_min <= 32'd0;
            y_min <= 63'd0;
            iter_count <= 0;
            done_op <= 1'b0;
            start_func_pulse <= 1'b0; // Initialize the pulse signal
        end else begin
            current_state <= next_state;
            // Default to de-assert start_func_pulse unless explicitly asserted
            start_func_pulse <= 1'b0; 

            case (current_state)
                STATE_IDLE : begin 
                    // DO NOTHING
                    done_op <= 1'b1;
                end
                STATE_INIT : begin 
                    x_in <= x_init;
                    y_min <= 64'h7FFFFFFFFFFFFFFF; // Initial y_min set to arbitrary high val
                    x_at_min <= x_init;
                    iter_count <= 0;
                    // start_func <= 1'b1; // This was the level
                end
                STATE_CALL_FUNC : begin 
                    // Assert start_func_pulse only for one cycle when entering this state
                    // This happens when current_state was STATE_INIT or STATE_CMP_STR
                    // and next_state is STATE_CALL_FUNC.
                    // A better way is to assert it when entering STATE_CALL_FUNC.
                    // This implies the previous state was STATE_INIT or STATE_CMP_STR
                    if (current_state != next_state) begin // This means we are transitioning to STATE_CALL_FUNC
                        start_func_pulse <= 1'b1;
                    end
                    if (func_done) begin
                        iter_count <= iter_count +1;
                        y_min_inter <= y_out;
                        x_at_min_inter <= x_in;
                        x_in <= x_next_val;
                        // start_func <= 1'b0; // This was part of level control
                    end
                end
                STATE_CMP_STR : begin
                    if (comp_result) begin
                        y_min <= y_min_inter;
                        x_at_min <= x_at_min_inter;
                    end
                    // When transitioning from STATE_CMP_STR back to STATE_CALL_FUNC,
                    // the start_func_pulse will be generated in the next clock cycle
                    // within STATE_CALL_FUNC's logic, based on the current_state != next_state check.
                    // start_func <= 1'b1; // This was part of level control
                end
                STATE_DONE : begin 
                    done_op <= 1'b1;
                end
            endcase
        end
    end

    // MODULE CALLS

    // Ouputs the Gradient & value of 'function under test' at x_in 
    func_grad_val_diff inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func_pulse), // Use the pulse signal here
        .x_in(x_in),
        .gradient(),
        .value(y_out),
        .func_done(func_done),
        .overflow()
    );

    
endmodule