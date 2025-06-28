`timescale 1ns / 1ps

module Top_tb;

// REG/WIRE DECLARATION

    reg signed [15:0] a_in_tb;
    reg signed [15:0] b_in_tb;
    wire signed [15:0] next_val_tb;
    wire overflow_out_tb;
    wire underflow_out_tb;


    Top uut (
        .a_in(a_in_tb),
        .b_in(b_in_tb),
        .next_val(next_val_tb),
        .overflow(overflow_out_tb),
        .underflow_q(underflow_out_tb)
    );

// Test sequence
    initial begin
        integer i;

        // Storing values for waveform simulation
        $dumpfile("Top_tb.vcd");
        $dumpvars(0, Top_tb);

        $display("---------------------------------------------------------");
        $display("--Starting Testbench for Capped Fixed-Point Multiplier---");
        $display("---------------------------------------------------------");

        // Initialize inputs to known values (CRITICAL)

        a_in_tb = 16'h0000; // 1.0 in Q8.8 format
        b_in_tb = 16'h0000; // 1.0 in Q8.8 format

        #10; // Allow initial values to propagate and UUT to compute

        for (i = 1; i < 11; i = i+1 )begin
            // For combinational logic, apply inputs and then wait for output
            // The #5 delay ensures combinational logic has time to settle

            $display("\n------- Test Case %0d: Input a = %f, b = %f (Q24.8) ------",
                     i, $itor(a_in_tb) / 256.0, $itor(b_in_tb) / 256.0); // Displaying Q24.8
            $display("a_in : %f (0x%H)", $itor(a_in_tb) / 256.0, a_in_tb);
            $display("b_in : %f (0x%H)", $itor(b_in_tb) / 256.0, b_in_tb);
            $display("next_val : %f (0x%H)", $itor(next_val_tb) / 256.0, next_val_tb); // next_val is Q8.8, so division by 256.0 is correct
            $display("Overflow: %b, Underflow: %b", overflow_out_tb, underflow_out_tb);


            // Increment inputs (e.g., by 0.25 in Q24.8 format)
            // 0.25 in Q24.8 is 0.25 * 2^8 = 64
            a_in_tb = a_in_tb - 32'h2000; // Increment by 96 (Q8.8)
            b_in_tb = b_in_tb + 32'h2000; // Increment by 96 (Q8.8)

            #10; // Wait for new inputs to propagate and output to settle
        end

        $display("---------------------------------------------------------");
        $display("-------Testbench Finished-------");
        $display("---------------------------------------------------------");
        $finish; // end simulation
    end

endmodule