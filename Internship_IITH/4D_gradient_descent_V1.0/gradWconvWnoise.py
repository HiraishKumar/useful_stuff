import numpy as np

# Define the function for which we want to find the minima
def objective_function(params):
    a, b, c, d = params
    # This function has a global minimum at a=2, b=0, c=-2, d=0, where the value is -5.
    # We can introduce a "local minima" feel by adding some bumps, though for a simple quadratic
    # like this, the noise is more about exploration than escaping a true local trap.
    # For a more illustrative example of escaping local minima, a multi-modal function would be better.
    return (a - 2)**2 + b**2 + (c + 2)**2 + (2*d)**2 - 5 + 0.1 * np.sin(5*a) + 0.1 * np.cos(5*b)

# Define the gradient of the function
def gradient(params):
    a, b, c, d = params
    grad_a = 2 * (a - 2) + 0.1 * 5 * np.cos(5*a) # Added gradient for the sine term
    grad_b = 2 * b - 0.1 * 5 * np.sin(5*b)     # Added gradient for the cosine term
    grad_c = 2 * (c + 2)
    grad_d = 2 * (2 * d) * 2 # Corrected derivative of (2*d)^2 is 2*(2*d)*2 = 8d
    return np.array([grad_a, grad_b, grad_c, grad_d])

def noisy_gradient_descent_output_convergence(objective_func, gradient_func, initial_params, learning_rate, num_iterations, noise_strength, convergence_threshold=0.001):
    """
    Gradient descent with convergence checking based on the change in output (objective function value).
    Stops when the absolute change in the objective function value becomes smaller than threshold.
    Includes noise to potentially skip over small local minima.
    
    Args:
        objective_func (callable): The function to minimize.
        gradient_func (callable): The gradient of the objective function.
        initial_params (list or np.array): The starting parameters for the optimization.
        learning_rate (float): The step size for each gradient update.
        num_iterations (int): The maximum number of iterations to perform.
        noise_strength (float): The magnitude of the random noise added to parameter updates.
                                A higher value means more noise.
        convergence_threshold (float): The threshold for the absolute change in the
                                       objective function value to consider convergence.
                                       
    Returns:
        tuple: A tuple containing:
            - np.array: The final optimized parameters.
            - list: A history of objective function values at each iteration.
    """
    params = np.array(initial_params, dtype=float)
    history = []
    
    print(f"Starting noisy gradient descent with output convergence threshold: {convergence_threshold}")
    print(f"Noise strength: {noise_strength}")
    print(f"Initial parameters: {params}")
    initial_value = objective_func(params)
    print(f"Initial function value: {initial_value:.4f}\n")
    history.append(initial_value) # Add initial value to history

    for i in range(num_iterations):
        # Calculate gradient
        grad = gradient_func(params)
        
        # Generate random noise
        # We use a normal distribution centered at 0.
        # The scale of the noise is controlled by noise_strength.
        noise = np.random.normal(loc=0, scale=noise_strength, size=params.shape)
        
        # Update parameters with gradient and added noise
        params = params - learning_rate * grad + noise
        
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
    # Parameters for the noisy gradient descent
    initial_parameters = [0.0, 0.0, 0.0, 0.0]
    learning_rate = 0.05 # Adjusted learning rate for potentially more complex landscape
    num_iterations = 200 # Increased iterations to allow noise to have effect
    convergence_threshold_output = 0.001  # Stop when output changes < 0.001
    noise_strength = 0.1 # New parameter: Controls the magnitude of the noise

    # Run noisy gradient descent with output convergence
    final_params_output, values_history_output = noisy_gradient_descent_output_convergence(
        objective_function,
        gradient,
        initial_parameters,
        learning_rate,
        num_iterations,
        noise_strength, # Pass the noise strength
        convergence_threshold_output
    )
    
    # Results
    print(f"\nFinal parameters: {np.round(final_params_output, 4)}")
    print(f"Final function value: {objective_function(final_params_output):.4f}")
    # Note: The theoretical minimum for the modified objective function is slightly different
    # due to the sine and cosine terms. The noise might help explore around the true minimum.
    print(f"Approximate theoretical minimum for base function: [2, 0, -2, 0] with value -5.0")
