module Top (
    input wire signed [15:0] fixed_point_in,    // 8.8 signed fixed point input
    output reg signed [7:0] rounded_integer_out       // 8-bit signed integer output
);

    localparam signed [7:0] MAX_8_BIT = 8'h7F;
    localparam signed [7:0] MIN_8_BIT = 8'h80;
    localparam signed [15:0] MAX_8_BIT_16 = 16'h7F00;
    localparam signed [15:0] MIN_8_BIT_16 = 16'h8000;
    localparam signed [15:0] OVERFLOW_CONST = 16'h007F;

    wire signed [16:0] temp_res;
    wire overflow;
    wire underflow;
    wire equal;

    assign temp_res = fixed_point_in + OVERFLOW_CONST;
    assign overflow = fixed_point_in > MAX_8_BIT_16;
    always @(*) begin        
        if (overflow) begin
            rounded_integer_out = MAX_8_BIT;
        end
        else begin
            rounded_integer_out = temp_res[15:8];
        end
    end
endmodule
   