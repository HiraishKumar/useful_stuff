`timescale 1ns / 1ps

module tb_Top;

    parameter INCREMENT = 16'h0A00;

    reg clk;
    reg rst_n;
    reg start_func;
    reg signed [15:0] a_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] b_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] c_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] d_input;          // 16 bit Q8.8 foramt
    reg signed [15:0] a_input_buffer;   // 16 bit Q8.8 foramt
    reg signed [15:0] b_input_buffer;   // 16 bit Q8.8 foramt
    reg signed [15:0] c_input_buffer;   // 16 bit Q8.8 foramt
    reg signed [15:0] d_input_buffer;   // 16 bit Q8.8 foramt

    wire signed [15:0] a_diff;                 // Distance of new A in Q8.8 format
    wire signed [15:0] b_diff;                 // Distance of new B in Q8.8 format
    wire signed [15:0] c_diff;                 // Distance of new C in Q8.8 format
    wire signed [15:0] d_diff;                 // Distance of new D in Q8.8 format
    
    wire func_done;
    wire [31:0] value;                  // 32 bit Q24.8 foramt
    wire overflow;

    Top uut(
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .a_in(a_input_buffer),          // 32 bit Q24.8 foramt
        .b_in(b_input_buffer),          // 32 bit Q24.8 foramt
        .c_in(c_input_buffer),          // 32 bit Q24.8 foramt
        .d_in(d_input_buffer),          // 32 bit Q24.8 foramt
        .value(value),
        .a_diff_out(a_diff),
        .b_diff_out(b_diff),
        .c_diff_out(c_diff),
        .d_diff_out(d_diff),
        .func_done(func_done), 
        .overflow(overflow)
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
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_Top);

        rst_n = 1'b0;      // Assert Reset
        start_func = 1'b0; // Disasset Start of func
        a_input = 16'h0000; // Initial Input
        b_input = 16'h0000; // Initial Input
        c_input = 16'h0000; // Initial Input
        d_input = 16'h0000; // Initial Input

        $display("---------------------------------------------------------");
        $display("---Starting Testbench for Polynomial Gradient Function---");
        $display("---------------------------------------------------------");

        #20 rst_n = 1'b1;  // Disassert reset

        for (i = 1; i < 17; i = i+1 )begin 
            a_input_buffer = a_input;
            b_input_buffer = b_input;
            c_input_buffer = c_input;
            d_input_buffer = d_input;
            
            start_func = 1'b1;
            //#20; // wait for ouput to settle

            wait(func_done == 1'b1);
            $display("\n--- Test Case %0d: Initial a = %f, b = %f, c = %f, d = %f, (Q8.8) ---", i, $itor(a_input) / 256.0, $itor(b_input) / 256.0, $itor(c_input) / 256.0, $itor(d_input) / 256.0);
            $display("a input : %f (0x%H)", $itor(a_input) / 256.0, a_input);
            $display("b input : %f (0x%H)", $itor(b_input) / 256.0, b_input);
            $display("c input : %f (0x%H)", $itor(c_input) / 256.0, c_input);
            $display("d input : %f (0x%H)", $itor(d_input) / 256.0, d_input);
            $display("z output: %f (0x%H)", $itor(value) / 256.0, value);
            $display(" a_diff : %f (0x%H)", $itor(a_diff) / 256.0, a_diff);
            $display(" b_diff : %f (0x%H)", $itor(b_diff) / 256.0, b_diff);
            $display(" c_diff : %f (0x%H)", $itor(c_diff) / 256.0, c_diff);
            $display(" d_diff : %f (0x%H)", $itor(d_diff) / 256.0, d_diff);

            start_func = 1'b0;
            wait(func_done == 1'b0);
            a_input = a_input + INCREMENT;  // decimal 2.0 in Q8.8 fromat
            b_input = b_input + INCREMENT;  // decimal 2.0 in Q8.8 fromat
            c_input = c_input + INCREMENT;  // decimal 2.0 in Q8.8 fromat
            d_input = d_input + INCREMENT;  // decimal 2.0 in Q8.8 fromat
            // #5;
        end
        $finish; // end simulation
    end
endmodule