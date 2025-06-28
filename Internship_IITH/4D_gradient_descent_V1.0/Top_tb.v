`timescale 1ns / 1ps

module Top_tb;

    parameter NUM_ITERATIONS = 50;
    parameter LEARNING_RATE = 32'h00000010; // Learning Rate of 0.125 (Q24.8)
    parameter INCREMENT = 16'h0F00;

    reg clk;
    reg rst_n;
    reg start_op;
    reg signed [15:0] a_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] b_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] c_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] d_input;          // 16 bit Q8.8 foramt

    reg signed [15:0] a_input_buffer;          // 16 bit Q8.8 foramt
    reg signed [15:0] b_input_buffer;          // 16 bit Q8.8 foramt
    reg signed [15:0] c_input_buffer;          // 16 bit Q8.8 foramt
    reg signed [15:0] d_input_buffer;          // 16 bit Q8.8 foramt

// WIRE DECLARATION
    wire signed [31:0] z_min;              // 32 bit Q24.8 foramt
    
    wire signed [15:0] a_min_out;          // 16 bit Q8.8 foramt
    wire signed [15:0] b_min_out;          // 16 bit Q8.8 foramt
    wire signed [15:0] c_min_out;          // 16 bit Q8.8 foramt
    wire signed [15:0] d_min_out;          // 16 bit Q8.8 foramt

    wire signed [7:0] a_min_read;          // 16 bit Q8.8 foramt
    wire signed [7:0] b_min_read;          // 16 bit Q8.8 foramt
    wire signed [7:0] c_min_read;          // 16 bit Q8.8 foramt
    wire signed [7:0] d_min_read;          // 16 bit Q8.8 foramt

    assign a_min_read = a_min_out[15:8];
    assign b_min_read = b_min_out[15:8];
    assign c_min_read = c_min_out[15:8];
    assign d_min_read = d_min_out[15:8];

    wire done_op;


    Top #(
        .NUM_ITERATIONS (NUM_ITERATIONS),
        .LEARNING_RATE (LEARNING_RATE )     // Decimal 0.125 Q24.8 format
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_op(start_op),
        .a_init(a_input_buffer),
        .b_init(b_input_buffer),
        .c_init(c_input_buffer),
        .d_init(d_input_buffer),
        .z_min(z_min),
        .a_at_min(a_min_out),
        .b_at_min(b_min_out),
        .c_at_min(c_min_out),
        .d_at_min(d_min_out),
        .done_op(done_op)
    );

// clk generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period (100 MHz) 
    end

// Test sequence 
    initial begin
        integer i;

        // Storing values for waveform simulation
        $dumpfile("Top_tb.vcd");
        $dumpvars(0, Top_tb);

        rst_n = 1'b0;      // Assert Reset
        start_op = 1'b0; // Disasset Start of func

        a_input = 16'h7F00; // Initial Input
        b_input = 16'h7F00; // Initial Input
        c_input = 16'h7F00; // Initial Input
        d_input = 16'h7F00; // Initial Input

        $display("---------------------------------------------------------");
        $display("----Starting Testbench for Default Polynomial Function---");
        $display("---------------------------------------------------------");

        #20 rst_n = 1'b1;  // Disassert reset

        for (i = 1; i < 17; i = i+1 )begin 
            a_input_buffer = a_input;
            b_input_buffer = b_input;
            c_input_buffer = c_input;
            d_input_buffer = d_input;

            start_op = 1'b1; // Assert Start
            rst_n = 1'b1; // Disassert reset
            //#20; // wait for ouput to settle
            wait(done_op == 1'b1);
            $display("\n-------------------Test Case %0d-------------------", i);
            $display("a input : %f (0x%H)", $itor(a_input) / 256.0, a_input);
            $display("b input : %f (0x%H)", $itor(b_input) / 256.0, b_input);
            $display("c input : %f (0x%H)", $itor(c_input) / 256.0, c_input);
            $display("d input : %f (0x%H)", $itor(d_input) / 256.0, d_input);
            $display("Z min: %f (0x%H)", $itor(z_min) / 256.0, z_min);
            $display("a min: %f (0x%H)", $itor(a_min_read), a_min_out);
            $display("b min: %f (0x%H)", $itor(b_min_read), b_min_out);
            $display("c min: %f (0x%H)", $itor(c_min_read), c_min_out);
            $display("d min: %f (0x%H)", $itor(d_min_read), d_min_out);
            $display("iter_count: %d ", uut.iter_count);
            $display("Convergence: %d ", uut.converged);

            #10;
            start_op = 1'b0; // Disassert start
            rst_n = 1'b0;    // assert reset
            #10;
            wait(done_op == 1'b0);
            
            a_input = a_input - INCREMENT;  // decimal 10 in Q8.8 fromat
            b_input = b_input - INCREMENT;  // decimal 10 in Q8.8 fromat
            c_input = c_input - INCREMENT;  // decimal 10 in Q8.8 fromat
            d_input = d_input - INCREMENT;  // decimal 10 in Q8.8 fromat
            //#20;
        end
        $finish; // end simulation
    end
endmodule