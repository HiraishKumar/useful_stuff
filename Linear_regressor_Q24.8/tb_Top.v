`timescale 1ns / 1ps

module tb_Top;

    // Parameters for the Top module (can be overridden here for testing)
    parameter NUM_ITERATIONS = 5;
    parameter OFFSET = 32'h00000400;        // Offset of 4 (Q24.8)
    parameter LEARNING_RATE = 32'h00000080; // Learning Rate of 0.5 (Q24.8)
    parameter INCREMENT = 32'h00000100;     // 1.0 Increment between test cases (Q24.8)
    parameter LOOP_COUNT = -703000;

    // Inputs to the Top module
    reg clk;
    reg rst_n;
    reg start_op;
    reg signed [31:0] initial_x_in;
    reg signed [31:0] test_x_val;

    // Outputs from the Top module
    wire signed [31:0] x_at_min;
    wire signed [31:0] y_min;
    wire done_op;
    wire signed [31:0] learning_rate_out; // Renamed to avoid conflict with parameter

    // Instantiate the Top module
    Top #(
        .NUM_ITERATIONS(NUM_ITERATIONS),
        .OFFSET(OFFSET),
        .LEARNING_RATE(LEARNING_RATE)
    ) uut_top (
        .clk(clk),
        .rst_n(rst_n),
        .start_op(start_op),
        .initial_x_in(initial_x_in),
        .x_at_min(x_at_min),
        .y_min(y_min),
        .done_op(done_op),
        .learning_rate_out(learning_rate_out)
    );


    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz)
    end

    // Test sequence
    initial begin
        integer i;
        // For waveform dumping (optional)
        $dumpfile("tb_Top.vcd");
        $dumpvars(0, tb_Top);

        // Initialize inputs
        rst_n = 0; // Assert reset
        start_op = 0;
        initial_x_in = 32'b0;
        test_x_val = 32'h00000000;

        $display("---------------------------------------------------------");
        $display("Starting Testbench for Fixed-Point Gradient Descent");
        $display("Parameters: NUM_ITERATIONS = %0d, OFFSET = %f, LEARNING_RATE = %f",
            NUM_ITERATIONS, $itor(OFFSET) / 256.0, $itor(LEARNING_RATE) / 256.0);
        $display("---------------------------------------------------------");
        #20 rst_n = 1; // Deassert reset        

        for(i = -700000; i > LOOP_COUNT; i = i - 1 ) begin
            initial_x_in = test_x_val; // Q24.8 (2's complement)
            start_op = 1;
            #20;

            wait(done_op == 1'b1);

            if ($abs($itor(x_at_min) / 256.0 - $itor(OFFSET) / 256.0) > 0.1) begin
                $display("___TEST BENCH FAILED___");
                $display("\n--- Test Case %0d: Initial x = %f (Q24.8) ---", i, $itor(test_x_val) / 256.0);
                $display("Initial X: %f", $itor(test_x_val) / 256.0);
                $display("Final X at Min: %f (0x%H)", $itor(x_at_min) / 256.0, x_at_min);
                $display("Min Y Value: %f (0x%H)", $itor(y_min) / 256.0, y_min);
                // break;
            end

            // Reset for next test
            start_op = 0;
            test_x_val = test_x_val - INCREMENT; // Increment set default to 1.0
            #20;
        end      
        $finish; // End simulation
    end
endmodule