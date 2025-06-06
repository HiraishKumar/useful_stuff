`timescale 1ns / 1ps

module tb_Top;

    reg clk;
    reg rst_n;
    reg start_func;
    reg signed [31:0] x_input;          // 32 bit Q24.8 foramt
    reg signed [31:0] x_input_buffer;   // 32 bit Q24.8 foramt
    

// WIRE DECLARATION
    wire func_done;
    wire [63:0] y_output;               // 64 bit Q56.8 foramt
    wire overflow;
    Top uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_func(start_func),
        .x_in(x_input_buffer), // 32 bit Q24.8 foramt
        .y_out(y_output),      // 64 bit Q56.8 foramt
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
        x_input = 32'h00000100; // Initial Input

        $display("---------------------------------------------------------");
        $display("----Starting Testbench for Default Polynomial Function---");
        $display("---------------------------------------------------------");

        #20 rst_n = 1'b1;  // Disassert reset

        for (i = 1; i < 11; i = i+1 )begin 
            start_func = 1'b1;
            x_input_buffer = x_input;
            #20; // wait for ouput to settle

            wait(func_done == 1'b1);
            $display("\n--- Test Case %0d: Initial x = %f (Q24.8) ---", i, $itor(x_input) / 256.0);
            $display("X input : %f (0x%H)", $itor(x_input) / 256.0, x_input);
            $display("Y output: %f (0x%H)", $itor(y_output) / 256.0, y_output);

            start_func = 1'b0;
            x_input = x_input + 32'h00000100;  // decimal 1 in Q24.8 fromat
            #20;
        end
        $finish; // end simulation
    end
endmodule