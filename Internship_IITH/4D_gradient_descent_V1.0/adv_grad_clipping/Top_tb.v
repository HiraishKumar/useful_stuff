`timescale 1ns / 1ps

module Top_tb;

// REG/WIRE DECLARATION
    // Inputs to the DUT must be 'reg'
    reg signed [15:0] fixed_in;

    // Outputs from the DUT will be 'wire'
    wire signed [7:0] rounded_out;
    parameter INCREMENT = 16'h0001;


    Top uut (
        .fixed_point_in(fixed_in),
        .rounded_integer_out(rounded_out)
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
        fixed_in = 16'h7FFA; 
                             

        #10; // Allow initial values to propagate and UUT to compute

        for (i = 1; i < 150; i = i+1 )begin
            // For combinational logic, apply inputs and then wait for output
            // The #5 delay ensures combinational logic has time to settle
            $display("\n------- Test Case %0d: Input a = %f ------",i, $itor(fixed_in) / 256.0); // Displaying Q24.8
            $display("Fixed_in : %f (0x%H) %b", $itor(fixed_in) / 256.0, fixed_in, fixed_in);
            $display("Round_out: %d (0x%H) %b", rounded_out, rounded_out, rounded_out);
            $display("Temp_res:     (0x%h) %b", uut.temp_res, uut.temp_res);
            $display("OverFlow: %d ", uut.overflow);
            // $display("Underflow: %d ", uut.underflow);
            // $display("Equal: %d ", uut.equal);
            fixed_in = fixed_in + INCREMENT; 

            // #10; // Wait for new inputs to propagate and output to settle
            #10;
        end

        $display("---------------------------------------------------------");
        $display("-------Testbench Finished-------");
        $display("---------------------------------------------------------");
        $finish; // end simulation
    end

endmodule