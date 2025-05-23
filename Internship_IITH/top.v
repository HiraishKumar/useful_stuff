`include "fixed_32_add_sub.v"
`include "fixed_32_cmp.v"
`include "fixed_32_mult.v"
`include "gradient_func.v"

module Top #(
    parameter NUM_ITERATIONS = 16,
    parameter OFFSET = 32'h00040000         // Offset of 4 from Y axis
    parameter LEARNING_RATE = 32'h00008000  // Learning Rate of 0.5
) (
    input clk,
    input rst_n,                            // Active Low reset
    input start_op,                         // Level Dtected Operation Start 
    input signed [31:0] initial_x_in,       // Initial X
    output reg signed [31:0] x_at_min,      // X at minimum value of function
    output reg signed [31:0] y_min,         // Minimum Values of fucntion
    output reg done_op                      // Flag to signal Completion of operation
);

// Internal register Declaration
reg signed [31:0] x;
reg [$clog2(NUM_ITERATIONS + 1) -1 : 0] iter_count;

// Register to hold current and next state

reg [1:0] current_state;
reg [1:0] next_state;

// Internal Wire Declaration

wire compare_result;
wire signed [31:0] gradient_out;
wire signed [31:0]
wire signed [31:0]
wire signed [31:0]

// State Machine State declaration

localparam STATE_IDLE    = 2'b00;
localparam STATE_INIT    = 2'b01;
localparam STATE_RUNNING = 2'b10;
localparam STAE_DONE     = 2'b11;

always @(*) begin
    

end



    
endmodule