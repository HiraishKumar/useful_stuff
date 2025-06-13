module func#(
    A0 = 32'h00000100   //1.0 in decimal Q24.8 format
    A1 = 32'h00000100   //1.0 in decimal Q24.8 format
    A2 = 32'h00000100   //1.0 in decimal Q24.8 format
    A3 = 32'h00000100   //1.0 in decimal Q24.8 format
    A4 = 32'h00000100   //1.0 in decimal Q24.8 format
)(
    input clk,
    input rst_n,
    input start_func,
    input signed [31:0] x_in,
    output reg signed [63:0] y_out,
    output reg func_done,
    output reg overflow
    // a4*​x^4 + a3*​x^3 + a2*​x^2 + a1*​x + a0​
);

// The default Function is assumed to be x^4-5x^2-3x

wire signed [127:0] x;          
wire signed [127:0] x_squ_inter;
wire signed [127:0] x_squ;
wire signed [127:0] x_cub_inter;
wire signed [127:0] x_cub;
wire signed [127:0] x_quad;


// --------------STAGE 1-------------------
fixed_128_mult(     // caclulate x^2
    .a_in({{32{x_in[31]}}, x_in }),     // 32 bit x_in sign extended to 64 bit
    .b_in({{32{x_in[31]}}, x_in }),     // 32 bit x_in sign extended to 64 bit
    .p_out(x_squ_inter),                // 128 bit product
    .overflow(),
    .underflow_q()
)

fixed_128_mult(     // caclulate a1*x
    .a_in({{32{x_in[31]}}, x_in }),     // 32 bit x_in sign extended to 64 bit
    .b_in({{32{A1[31]}}, A1 }),         // 32 bit x_in sign extended to 64 bit
    .p_out(x),                          // 128 bit product
    .overflow(),
    .underflow_q()
)
// ------------STAGE 1-----------------------

// ------------STAGE 2-------------------------
fixed_128_mult(     // caclulate x^3
    .a_in({{32{x_in[31]}}, x_in }),     // 32 bit x_in sign extended to 64 bit
    .b_in(x_squ_inter),                 // 64 bit x_squ 
    .p_out(x_cub_inter),                // 128 bit product
    .overflow(),
    .underflow_q()
)

fixed_128_mult(     // caclulate a2*x^2
    .a_in({{32{x_in[31]}}, x_in }),     // 32 bit x_in sign extended to 64 bit
    .b_in({{32{A1[31]}}, A1 }),         // 32 bit x_in sign extended to 64 bit
    .p_out(x_squ),                      // 128 bit product
    .overflow(),
    .underflow_q()
)


// ------------STAGE 2-------------------------


localparam IDLE             = 3'b000;
localparam INIT             = 3'b001;
localparam COMP_1           = 3'b010;   // calculate a1*x, x^2
localparam COMP_2           = 3'b011;   // calculate a2*x^2, x^3, x^4, (a1*x + a0)
localparam COMP_3           = 3'b100;   // calculate a3*x^3, a4*x^4, ((a1*x + a0) + a2*x^2)
localparam COMP_4           = 3'b101;   // calculate (a3*x^3 + a4*x^4)
localparam COMP_5           = 3'b110;   // calculate ((a3*x^3 + a4*x^4) + ((a1*x + a0) + a2*x^2))
localparam STATE_DONE       = 3'b111;




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
        y_out       <= MINUS_ONE; 
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