// Convergence Checker Module
module convergence_checker #(
    parameter CONVERGENCE_THRESHOLD = 16'h0100  // 1.0 in Q8.8 format (256 in decimal)
) (
    input clk,
    input rst_n,
    input check_enable,                    // Enable convergence checking
    input signed [15:0] a_current,         // Current parameter values Q8.8
    input signed [15:0] b_current,
    input signed [15:0] c_current,
    input signed [15:0] d_current,
    input signed [15:0] a_step,            // Step sizes Q8.8 (optional method)
    input signed [15:0] b_step,
    input signed [15:0] c_step,
    input signed [15:0] d_step,
    input use_step_method,                 // 1 = use step sizes, 0 = use parameter changes
    input [$clog2(50 + 1)-1:0] iter_count, // Current iteration count
    output reg converged,                  // Convergence flag
    output reg [15:0] max_change_debug     // Debug: largest parameter change
);

    // Internal registers for previous parameter values
    reg signed [15:0] a_prev, b_prev, c_prev, d_prev;
    reg prev_values_valid;  // Flag to indicate we have valid previous values

    // Wires for parameter changes and step sizes
    wire [15:0] param_a_diff, param_b_diff, param_c_diff, param_d_diff;
    wire [15:0] step_a_abs, step_b_abs, step_c_abs, step_d_abs;
    
    // Absolute values for parameter changes
    wire [15:0] abs_param_a_diff, abs_param_b_diff, abs_param_c_diff, abs_param_d_diff;
    
    // Individual convergence flags
    wire a_converged, b_converged, c_converged, d_converged;
    
    // Values to check (either parameter changes or step sizes)
    wire [15:0] check_a, check_b, check_c, check_d;

    // Calculate parameter changes (current - previous)
    assign param_a_diff = a_current - a_prev;
    assign param_b_diff = b_current - b_prev;
    assign param_c_diff = c_current - c_prev;
    assign param_d_diff = d_current - d_prev;

    // Absolute values for parameter changes
    assign abs_param_a_diff = (param_a_diff[15]) ? (~param_a_diff + 1'b1) : param_a_diff;
    assign abs_param_b_diff = (param_b_diff[15]) ? (~param_b_diff + 1'b1) : param_b_diff;
    assign abs_param_c_diff = (param_c_diff[15]) ? (~param_c_diff + 1'b1) : param_c_diff;
    assign abs_param_d_diff = (param_d_diff[15]) ? (~param_d_diff + 1'b1) : param_d_diff;

    // Absolute values for step sizes
    assign step_a_abs = (a_step[15]) ? (~a_step + 1'b1) : a_step;
    assign step_b_abs = (b_step[15]) ? (~b_step + 1'b1) : b_step;
    assign step_c_abs = (c_step[15]) ? (~c_step + 1'b1) : c_step;
    assign step_d_abs = (d_step[15]) ? (~d_step + 1'b1) : d_step;

    // Select which values to check based on method
    assign check_a = use_step_method ? step_a_abs : abs_param_a_diff;
    assign check_b = use_step_method ? step_b_abs : abs_param_b_diff;
    assign check_c = use_step_method ? step_c_abs : abs_param_c_diff;
    assign check_d = use_step_method ? step_d_abs : abs_param_d_diff;

    // Individual parameter convergence checks
    assign a_converged = (check_a < CONVERGENCE_THRESHOLD);
    assign b_converged = (check_b < CONVERGENCE_THRESHOLD);
    assign c_converged = (check_c < CONVERGENCE_THRESHOLD);
    assign d_converged = (check_d < CONVERGENCE_THRESHOLD);

    // Find maximum change for debugging
    wire [15:0] max_ab = (check_a > check_b) ? check_a : check_b;
    wire [15:0] max_cd = (check_c > check_d) ? check_c : check_d;
    wire [15:0] max_all = (max_ab > max_cd) ? max_ab : max_cd;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 16'd0;
            b_prev <= 16'd0;
            c_prev <= 16'd0;
            d_prev <= 16'd0;
            prev_values_valid <= 1'b0;
            converged <= 1'b0;
            max_change_debug <= 16'd0;
        end else begin
            if (check_enable) begin
                // Store current values as previous for next check
                a_prev <= a_current;
                b_prev <= b_current;
                c_prev <= c_current;
                d_prev <= d_current;
                prev_values_valid <= 1'b1;
                
                // Update debug output
                max_change_debug <= max_all;
                
                // Check convergence
                if (use_step_method) begin
                    // For step method, can check immediately
                    converged <= (a_converged && b_converged && c_converged && d_converged);
                end else begin
                    // For parameter change method, need valid previous values and iter_count > 1
                    if (prev_values_valid && iter_count > 1) begin
                        converged <= (a_converged && b_converged && c_converged && d_converged);
                    end else begin
                        converged <= 1'b0;
                    end
                end
            end else begin
                // Reset convergence flag when not checking
                converged <= 1'b0;
            end
        end
    end

endmodule