// TODO:
//      {DONE} Finish func_grad_val_diff.v using |||FSM||| (Ditched FSM)
//      {DONE} Finish Top.v implementing func_grad_val_diff
//      Write Testbech for Top.v
// TODO AFTER:
//      Write synthesis in vivado 



module Top #(
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
    reg signed [31:0] x_in;     // Q24.8 format
    reg [$clog2(NUM_ITERATIONS + 1)-1 : 0] iter_count;
    reg func_reset;     
    reg start_func;      
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
    wire [31:0] x_diff_out;

    // STATE DEFINITION
    localparam STATE_IDLE = 3'b000;
    localparam STATE_INIT = 3'b001;
    localparam STATE_CALL_FUNC = 3'b010; 
    localparam STATE_CMP_STR = 3'b011; // COMPARE AND STORE
    localparam STATE_DONE = 3'b100;

    assign x_next_val = (x_in - x_diff_out);
        
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

    //           STATE_IDLE---------( start_op == 1)--------->STATE_INIT
    //               ʌ                                             |    
    //               |           MOVE TO IDLE WHENEVER             |
    //               |             start_op is UNSET               |
    //       (start_op == 0 )                                STATE_CALL_FUNC<-----\
    //               ʌ                                             V              |            
    //               |                                             |              |
    //           STATE_DONE<---(iter_count == NUM_ITERATIONS)<--STATE_CMP_STR     |
    //                                                             |              ʌ
    //                                                             L > (iter_count < NUM_ITERATIONS)



    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            current_state <= STATE_IDLE;
            x_in <= 32'd0;
            x_at_min <= 32'd0;
            y_min <= 64'd0;
            y_min_inter <= 64'd0;        // Add this
            x_at_min_inter <= 32'd0;     // Add this
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
                    x_in <= x_init;
                    y_min <= 64'h7FFFFFFFFFFFFFFF; // Initial y_min set to arbitrary high val
                    x_at_min <= x_init;
                    y_min_inter <= 64'h7FFFFFFFFFFFFFFF;  // Add this
                    x_at_min_inter <= x_init;             // Add this
                    iter_count <= 0;
                    start_func <= 1'b1;
                end
                STATE_CALL_FUNC : begin 
                    if (func_done) begin
                        iter_count <= iter_count +1;
                        y_min_inter <= y_out;
                        x_at_min_inter <= x_in;
                        start_func <= 1'b0;
                    end
                end
                STATE_CMP_STR : begin
                    if (comp_result) begin
                        y_min <= y_min_inter;
                        x_at_min <= x_at_min_inter;
                    end
                    x_in <= x_next_val;
                    start_func <= 1'b1;
                end
                STATE_DONE : begin 
                    done_op <= 1'b1;
                end
            endcase
        end
    end

    // MODULE CALLS

    // Ouputs the Gradient, value & Step size of 'function under test' at x_in 
    func_grad_val_diff inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),// input level Flag signaling Start of function
        .x_in(x_in),            // X input of the function
        .gradient(),            // Gradient Output of the function at X
        .value(y_out),          // value of func at X
        .x_diff_out(x_diff_out),// calculated Step size to next X 
        .func_done(func_done),  // Flag so signaling func completion
        .overflow()             // Overflow Flag
    );
    fixed_64_comp compare(
        .a_in(y_min_inter),
        .b_in(y_min),
        .comp_result(comp_result)   // out put 1 if y_min_inter < y_min
    );

    
endmodule