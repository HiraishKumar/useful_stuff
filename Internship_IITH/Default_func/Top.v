module Top(
    input clk,
    input rst_n,
    input start_func,
    input signed [31:0] x_in,
    output reg signed [63:0] y_out,
    output logic func_done,
    output logic overflow
);

// The default Function is assumed to be X^2 + 4x - 1

localparam STATE_IDLE       = 2'b00;
localparam STATE_INIT       = 2'b01;
localparam STATE_COMPUTE    = 2'b10;
localparam STATE_DONE       = 2'b11;
localparam MINUS_ONE        = 64'hFFFFFFFFFFFFFF00;

reg [1:0] curr_state;
reg [1:0] next_state;
reg compute_done ;
reg signed [31:0] x_val;
reg signed [63:0] four_x;
reg signed [63:0] compute_result;

wire signed [63:0] x_square;
wire overflow_x_square;

always @(*) begin
    next_state = curr_state;
    case (curr_state)
        STATE_IDLE      : begin if (start_func)  next_state = STATE_INIT; end
        STATE_INIT      : begin next_state = STATE_COMPUTE; end
        STATE_COMPUTE   : begin if (compute_done) next_state = STATE_DONE; end
        STATE_DONE      : begin if (!start_func) next_state = STATE_IDLE; end
        default         : begin next_state = STATE_IDLE; end
    endcase
    four_x = x_val << 2; // SIGN EXTENED
    compute_result = x_square + four_x + MINUS_ONE;  // Q56.8 format
end

always_ff @(posedge clk, negedge rst_n) begin 
    if (!rst_n) begin
        curr_state  <= STATE_IDLE;
        func_done   <= 1'b0;
        x_val       <= 32'd0;   
        y_out       <= 64'd0;
        compute_done <= 1'b0;
        overflow    <= 1'b0;
    end else begin 
        curr_state <= next_state;
        case (curr_state)
            STATE_IDLE : begin
                // DO NOTHING
                func_done <= 1'b0;
                compute_done <= 1'b0;   
            end  
            STATE_INIT : begin
                x_val <= x_in;
                y_out <= 64'd0;
                func_done <= 1'b0;
                compute_done <= 1'b0;   
            end
            STATE_COMPUTE: begin 
                y_out <= compute_result;
                compute_done <= 1'b1;
                overflow <= overflow_x_square;
            end
            STATE_DONE : begin 
                func_done <= 1'b1;
            end
        endcase
    end 
end

fixed_64_mult inst (   // calculate x^2
    .a_in(x_val),
    .b_in(x_val),
    .p_out(x_square),
    .overflow(overflow_x_square)
);

endmodule