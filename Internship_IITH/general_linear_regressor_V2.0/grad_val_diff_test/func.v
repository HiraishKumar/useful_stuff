module func #(
    A0 = 32'h00000100,   //1.0 in decimal Q24.8 format
    A1 = 32'h00000000,  //0.0 in decimal Q24.8 format
    A2 = 32'hFFFFFF80,   //-0.5 in decimal Q24.8 format
    A3 = 32'h00000000,   //0.0 in decimal Q24.8 format
    A4 = 32'h0000000A   //0.0390625 in decimal Q24.8 format
)(
    input clk,
    input rst_n,
    input start_func,
    input signed [31:0] x_in,  
    output reg signed [127:0] y_out,
    output reg func_done,
    output reg overflow
    // a4*​x^4 + a3*​x^3 + a2*​x^2 + a1*​x + a0​
    // SET UP COS(x)
);


// wire signed [127:0] x;          
wire signed [127:0] term1;
wire signed [127:0] term2_partial;
wire signed [127:0] term2;
wire signed [127:0] term3_partial;
wire signed [127:0] term3;
wire signed [127:0] term4_partial;
wire signed [127:0] term4;
wire signed [127:0] term0_add_term1_out;
wire signed [127:0] term0_add_term1_add_term2_out;
wire signed [127:0] term3_add_term4_out;
wire signed [127:0] final_polynomial;


// STAGE 1: Calculate_product -> A1 * x, x * x
// STAGE 1: Calculate_SUM     -> --Nil--

// STAGE 2: Calculate_product -> A2 * x^2, x^2 * x, x^2 * x^2
// STAGE 2: Calculate_SUM     -> A1*x + A0

// STAGE 3: Calculate_product -> A3 * x^3, A4 * x^4
// STAGE 3: Calculate_SUM     -> (A1*x + A0) + A2*x^2

// STAGE 4: Calculate_product -> --Nil--
// STAGE 4: Calculate_SUM     -> A3*x^3 + A4*x^4

// STAGE 5: Calculate_product -> --Nil--
// STAGE 5: Calculate_SUM     -> ((A1*x + A0) + A2*x^2) + (A3*x^3 + A4*x^4)  -> Final Plynomial 



// --------------STAGE 1-------------------
fixed_128_mult term1_inst(              // caclulate a1*x
    .a_in({{96{x_val[31]}}, x_val }),   // 32 bit Q24.8 x_val sign extended to 128 bit Q56.8
    .b_in({{96{A1[31]}}, A1 }),         // 32 bit Q24.8 constant sign extended to 128 bit Q56.8
    .p_out(term1),                      // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

fixed_128_mult x_sq_par(                // caclulate x^2
    .a_in({{96{x_val[31]}}, x_val }),     // 32 bit Q24.8 x_val sign extended to 128 bit Q56.8
    .b_in({{96{x_val[31]}}, x_val }),     // 32 bit Q24.8 x_val sign extended to 128 bit Q56.8
    .p_out(term2_partial),              // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

// ------------STAGE 1-----------------------

// ------------STAGE 2-------------------------
fixed_128_mult term2_inst(              // caclulate a2*x^2
    .a_in(term2_partial),               // 64 bit x^2 
    .b_in({{96{A2[31]}}, A2}),          // 32 bit constant sign extended to 128 bit
    .p_out(term2),                      // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

fixed_128_mult x_cu_par(                // caclulate x^3
    .a_in({{96{x_val[31]}}, x_val }),     // 32 bit x_in sign extended to 128 bit
    .b_in(term2_partial),               // 64 bit term2 
    .p_out(term3_partial),              // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);


fixed_128_mult x_qu_par(                // caclulate x^4
    .a_in(term2_partial),               // 64 bit x^2 partial 
    .b_in(term2_partial),               // 64 bit x^2 partial 
    .p_out(term4_partial),              // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

fixed_128_add term0_add_term1(          // term1 + term0
    .a_in(term1),                       // 128 bit term 1
    .b_in({{96{A0[31]}}, A0 }),         // 32 bit x_in sign extended to 128 bit
    .sum(term0_add_term1_out),        // 128 bit sum term0 + term 1 Q120:8
    .overflow(),
    .underflow_q()
);

// ------------STAGE 2-------------------------

// ------------STAGE 3-------------------------

fixed_128_mult term3_inst (             // caclulate a3*x^3
    .a_in(term3_partial),               // 64 bit x^3 partial 
    .b_in({{96{A3[31]}}, A3 }),         // 32 bit constant sign extended to 128 bit
    .p_out(term3),                      // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

fixed_128_mult term4_inst (             // caclulate a4*x^4
    .a_in(term4_partial),               // 64 bit x^4 partial 
    .b_in({{96{A4[31]}}, A4 }),         // 32 bit constant sign extended to 128 bit
    .p_out(term4),                      // 128 bit product Q120:8 
    .overflow(),
    .underflow_q()
);

fixed_128_add term0_add_term1_add_term2(// term0 + term1 + term2 
    .a_in(term0_add_term1_out),         // 128 bit term0 + term 1 
    .b_in(term2),                       // 128 bit term2
    .sum(term0_add_term1_add_term2_out),  // 128 bit sum term0 + term1 + term2 Q120:8
    .overflow(),
    .underflow_q()
);


// ------------STAGE 3-------------------------

// ------------STAGE 4-------------------------


fixed_128_add term3_add_term4(          // term3 + term4
    .a_in(term3),                       // 128 bit term 3
    .b_in(term4),                       // 128 bit term 4
    .sum(term3_add_term4_out),        // 128 bit sum term3 + term4 
    .overflow(),
    .underflow_q()
);


// ------------STAGE 4-------------------------

// ------------STAGE 5-------------------------

fixed_128_add final_poly(               // final term0 + term1 + term2 + term3 + term4
    .a_in(term3_add_term4_out),         // 128 bit term3 + term4
    .b_in(term0_add_term1_add_term2_out),// 128 bit term0 + term1 + term2 
    .sum(final_polynomial),           // 128 bit sum final
    .overflow(),
    .underflow_q()
);

// ------------STAGE 5-------------------------


localparam IDLE             = 3'b000;
localparam INIT             = 3'b001;
localparam COMP_1           = 3'b010;   // calculate a1*x, x^2
localparam COMP_2           = 3'b011;   // calculate a2*x^2, x^3, x^4, (a1*x + a0)
localparam COMP_3           = 3'b100;   // calculate a3*x^3, a4*x^4, ((a1*x + a0) + a2*x^2)
localparam COMP_4           = 3'b101;   // calculate (a3*x^3 + a4*x^4)
localparam COMP_5           = 3'b110;   // calculate ((a3*x^3 + a4*x^4) + ((a1*x + a0) + a2*x^2))
localparam STATE_DONE       = 3'b111;



reg [2:0] curr_state;
reg [2:0] next_state;
reg compute_done ;
reg signed [31:0] x_val;



always @(*) begin
    next_state = curr_state;
    case (curr_state)
        IDLE        : begin if (start_func)  next_state = INIT; end
        INIT        : begin next_state = COMP_1; end
        COMP_1      : begin next_state = COMP_2; end
        COMP_2      : begin next_state = COMP_3; end
        COMP_3      : begin next_state = COMP_4; end
        COMP_4      : begin next_state = COMP_5; end
        COMP_5      : begin next_state = STATE_DONE; end
        STATE_DONE  : begin if (!start_func) next_state = IDLE; end
        default     : begin next_state = IDLE; end
    endcase

end

always_ff @(posedge clk, negedge rst_n) begin 
    if (!rst_n) begin
        curr_state  <= IDLE;
        func_done   <= 1'b0;
        x_val       <= 32'd0;   
        y_out       <= 128'd0; 
        compute_done <= 1'b0;
        overflow    <= 1'b0;
    end else begin 
        curr_state <= next_state;
        case (curr_state)
            IDLE : begin
                // DO NOTHING
                func_done <= 1'b0;
                compute_done <= 1'b0;   
            end  
            INIT : begin
                x_val <= x_in;
                y_out <= 128'd0;
                func_done <= 1'b0;
                compute_done <= 1'b0;   
            end
            COMP_5: begin 
                y_out <= final_polynomial;
                compute_done <= 1'b1;
                overflow <= 1'b0;  
            end
            STATE_DONE : begin 
                func_done <= 1'b1;
            end
            default : begin
                // DO NOTHING
            end
        endcase
    end 
end


endmodule