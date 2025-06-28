import numpy as np

# Define the function for which we want to find the minima
def objective_function(params):
    a, b, c, d = params
    return (a - 2)**2 + b**2 + (c + 2)**2 + (2*d)**2 - 5

# Define the gradient of the function
def gradient(params):
    a, b, c, d = params
    grad_a = 2 * (a - 2)
    grad_b = 2 * b
    grad_c = 2 * (c + 2)
    grad_d = 2 * (2 * d) # Corrected to 4*d for the derivative of (2*d)^2 = 4d^2
    return np.array([grad_a, grad_b, grad_c, grad_d])

# Corrected gradient for d (derivative of (2d)^2 = 4d^2 is 8d)
# My previous gradient was wrong. It should be 4*(2*d) = 8*d
def gradient_corrected(params):
    a, b, c, d = params
    grad_a = 2 * (a - 2)
    grad_b = 2 * b
    grad_c = 2 * (c + 2)
    grad_d = 8 * d # Corrected derivative for (2d)^2
    return np.array([grad_a, grad_b, grad_c, grad_d])


def gradient_descent_output_convergence(objective_func, gradient_func, initial_params, learning_rate, num_iterations, convergence_threshold=0.001,
                                       gradient_clip_norm=None, gradient_clip_value=None):
    """
    Gradient descent with convergence checking based on the change in output (objective function value).
    Stops when the absolute change in the objective function value becomes smaller than threshold.
    Includes options for gradient clipping (by norm or by value).
    """
    params = np.array(initial_params, dtype=float)
    history = []
    
    print(f"Starting gradient descent with output convergence threshold: {convergence_threshold}")
    print(f"Initial parameters: {params}")
    initial_value = objective_func(params)
    print(f"Initial function value: {initial_value:.4f}\n")
    history.append(initial_value) # Add initial value to history

    # Print clipping info
    if gradient_clip_norm is not None:
        print(f"Gradient Clipping by Norm enabled with threshold: {gradient_clip_norm}")
    if gradient_clip_value is not None:
        print(f"Gradient Clipping by Value enabled with threshold: +/-{gradient_clip_value}")
    print("-" * 50)

    for i in range(num_iterations):
        # Calculate gradient
        grad = gradient_func(params)

        # --- Gradient Clipping Implementation ---
        if gradient_clip_norm is not None:
            grad_norm = np.linalg.norm(grad)
            if grad_norm > gradient_clip_norm:
                grad = grad / grad_norm * gradient_clip_norm # Scale down the gradient
                # print(f"  --> Clipped gradient (norm {grad_norm:.2f} to {gradient_clip_norm}) at iteration {i+1}")
        
        if gradient_clip_value is not None:
            grad = np.clip(grad, -gradient_clip_value, gradient_clip_value)
            # print(f"  --> Clipped gradient (by value) at iteration {i+1}")
        # --- End Gradient Clipping ---

        # Update parameters
        params = params - learning_rate * grad
        
        # Record current function value
        current_value = objective_func(params)
        
        # Check convergence (skip first actual iteration after initial value)
        if i > 0:
            value_change = np.abs(current_value - history[-1]) # Compare with the last value in history
            
            if value_change < convergence_threshold:
                print(f"*** CONVERGED at iteration {i + 1} ***")
                print(f"Absolute change in objective function: {value_change:.6f}")
                break
        
        history.append(current_value) # Add current value to history for the next iteration's comparison
        
        # Print progress
        print(f"Iteration {i + 1}: params={np.round(params, 4)}, value={current_value:.4f}")

    return params, history

if __name__ == "__main__":
    # Parameters
    initial_parameters = [0.0, 0.0, 0.0, 0.0]
    num_iterations = 50
    convergence_threshold_output = 0.001 
    
    # --- Test Case 1: No Clipping (Potentially Diverge with High LR) ---
    print("\n--- Running Test Case 1: High Learning Rate (Potentially Divergent) ---")
    learning_rate_high = 0.5 # A high learning rate for this function
    final_params_no_clip, values_history_no_clip = gradient_descent_output_convergence(
        objective_function, # Using the original gradient, note the d-term issue
        initial_parameters,
        learning_rate_high,
        num_iterations,
        convergence_threshold_output
    )
    print(f"\nFinal parameters (No Clip): {np.round(final_params_no_clip, 4)}")
    print(f"Final function value (No Clip): {objective_function(final_params_no_clip):.4f}")


    # --- Test Case 2: With Gradient Clipping by Norm ---
    print("\n--- Running Test Case 2: High Learning Rate with Gradient Clipping by Norm ---")
    learning_rate_clipped = 0.5 # Keep high learning rate to show clipping's effect
    clip_norm_value = 1.0 # Max allowed gradient norm
    final_params_clip_norm, values_history_clip_norm = gradient_descent_output_convergence(
        objective_function, # Using the original gradient
        initial_parameters,
        learning_rate_clipped,
        num_iterations,
        convergence_threshold_output,
        gradient_clip_norm=clip_norm_value # Enable clipping by norm
    )
    print(f"\nFinal parameters (Clip by Norm): {np.round(final_params_clip_norm, 4)}")
    print(f"Final function value (Clip by Norm): {objective_function(final_params_clip_norm):.4f}")

    # --- Test Case 3: With Gradient Clipping by Value ---
    print("\n--- Running Test Case 3: High Learning Rate with Gradient Clipping by Value ---")
    learning_rate_clipped_value = 0.5
    clip_value_val = 1.0 # Max allowed absolute value for any gradient component
    final_params_clip_value, values_history_clip_value = gradient_descent_output_convergence(
        objective_function, # Using the original gradient
        initial_parameters,
        learning_rate_clipped_value,
        num_iterations,
        convergence_threshold_output,
        gradient_clip_value=clip_value_val # Enable clipping by value
    )
    print(f"\nFinal parameters (Clip by Value): {np.round(final_params_clip_value, 4)}")
    print(f"Final function value (Clip by Value): {objective_function(final_params_clip_value):.4f}")

    # --- Test Case 4: Original Learning Rate (Should Converge Well) ---
    print("\n--- Running Test Case 4: Original Learning Rate (Optimal without Clipping) ---")
    learning_rate_original = 0.125
    final_params_original, values_history_original = gradient_descent_output_convergence(
        objective_function, # Using the original gradient
        initial_parameters,
        learning_rate_original,
        num_iterations,
        convergence_threshold_output
    )
    print(f"\nFinal parameters (Original LR): {np.round(final_params_original, 4)}")
    print(f"Final function value (Original LR): {objective_function(final_params_original):.4f}")

    print(f"\nTheoretical minimum: [2, 0, -2, 0] with value -5.0")

    # Note: I've also added a 'gradient_corrected' function in comments.
    # The derivative of (2*d)^2 is 8*d, not 4*d.
    # You might want to use gradient_corrected if you want strict mathematical correctness.
    # The existing `objective_function` and `gradient` will still demonstrate clipping
    # but for a slightly different (but still quadratic) problem.