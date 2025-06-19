module backup(
    input clk,
    input rst_n,
    input start_func,
    input signed [15:0] a_in,       // Q8.8 format
    input signed [15:0] b_in,       // Q8.8 format
    input signed [15:0] c_in,       // Q8.8 format
    input signed [15:0] d_in,       // Q8.8 format
    output reg signed [31:0] z_out, // Q24.8 format
    output logic func_done,
    output logic overflow
);
    // func is assumed to be (a-2)^2 + b^2 + (c+2)^2 + (5*d)^2 - 5
    
    localparam IDLE         = 3'b000;
    localparam INIT         = 3'b001;
    localparam COMP_MULT    = 3'b010;
    localparam COMP_SUM     = 3'b011;
    localparam DONE         = 3'b100;
    localparam MINUS_FIVE   = 32'hFFFFFB00;

    reg signed  [15:0]  a_in_buffer;
    wire signed [31:0]  a_square;
    reg signed  [31:0]  a_square_reg;
    reg signed  [15:0]  b_in_buffer;
    wire signed [31:0]  b_square;
    reg signed  [31:0]  b_square_reg;
    reg signed  [31:0]  z_buffer;

    reg [2:0] curr_state;
    reg [2:0] next_state;

    fixed_32_mult x_sq (    // calculate x^2
        .a_in({{16{a_in_buffer[15]}},a_in_buffer}),
        .b_in({{16{a_in_buffer[15]}},a_in_buffer}),
        .p_out(a_square),
        .overflow(),
        .underflow_q()
    );
    fixed_32_mult y_sq (    // calculate y^2
        .a_in({{16{b_in_buffer[15]}},b_in_buffer}),
        .b_in({{16{b_in_buffer[15]}},b_in_buffer}),
        .p_out(b_square),
        .overflow(),
        .underflow_q()
    );


    always @(*) begin
        next_state = curr_state;
        case (curr_state)
            IDLE        : begin if (start_func == 1'b1) next_state = INIT; end
            INIT        : begin next_state = COMP_MULT; end
            COMP_MULT   : begin next_state = COMP_SUM; end 
            COMP_SUM    : begin next_state = DONE; end 
            DONE        : begin if (!start_func) next_state = IDLE; end
            default     : begin next_state = IDLE; end
        endcase
    end

    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n) begin
            a_in_buffer <=  16'd0;
            b_in_buffer <=  16'd0;
            z_out       <=  32'd0;
            curr_state  <=  IDLE;
            func_done   <=  1'b0;
            overflow    <=  1'b0;
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
                end
                COMP_MULT: begin
                    a_square_reg <= a_square;
                    b_square_reg <= b_square;
                    // DO NOTHING
                end
                COMP_SUM: begin
                    // DO NOTHING
                    z_buffer <= a_square_reg + b_square_reg;
                end
                DONE: begin
                    func_done <= 1'b1;
                    z_out <= z_buffer + MINUS_FIVE;
                end
            endcase
        end
    end



endmodule




// always @(*) begin
//     next_state = curr_state;
//     case (curr_state)
//         IDLE        : begin if (start_func)  next_state = INIT; end
//         INIT        : begin next_state = COMP_1; end
//         COMP_1      : begin next_state = COMP_2; end
//         COMP_2      : begin next_state = COMP_3; end
//         COMP_3      : begin next_state = COMP_4; end
//         COMP_4      : begin next_state = COMP_5; end
//         COMP_5      : begin next_state = STATE_DONE; end
//         STATE_DONE  : begin if (!start_func) next_state = IDLE; end
//         default     : begin next_state = IDLE; end
//     endcase

// end

// always_ff @(posedge clk, negedge rst_n) begin 
//     if (!rst_n) begin
//         curr_state  <= IDLE;
//         func_done   <= 1'b0;
//         x_val       <= 32'd0;   
//         y_out       <= 128'd0; 
//         compute_done <= 1'b0;
//         overflow    <= 1'b0;
//     end else begin 
//         curr_state <= next_state;
//         case (curr_state)
//             IDLE : begin
//                 // DO NOTHING
//                 func_done <= 1'b0;
//                 compute_done <= 1'b0;   
//             end  
//             INIT : begin
//                 x_val <= x_in;
//                 y_out <= 128'd0;
//                 func_done <= 1'b0;
//                 compute_done <= 1'b0;   
//             end
//             COMP_5: begin 
//                 y_out <= final_polynomial;
//                 compute_done <= 1'b1;
//                 overflow <= 1'b0;  
//             end
//             STATE_DONE : begin 
//                 func_done <= 1'b1;
//             end
//             default : begin
//                 // DO NOTHING
//             end
//         endcase
//     end 
// end
