import numpy as np
import matplotlib.pyplot as plt

# 1. Define the function f(x) = x^4 - 5x^2 - 3x
def f(x):
    """
    The function to minimize.
    f(x) = x^4 - 5x^2 - 3x
    """
    return x**4 - 5*x**2 - 3*x

# 2. Define the derivative of the function df(x) = 4x^3 - 10x - 3
def df(x):
    """
    The derivative of the function f(x).
    df(x) = 4x^3 - 10x - 3
    """
    return 4*x**3 - 10*x - 3

def gradient_descent_with_momentum(
    initial_x,
    learning_rate,
    momentum_coefficient, # Often denoted as beta (β)
    num_iterations
):
    """
    Performs Gradient Descent with Momentum to find the minimum of a 1D function.

    Args:
        initial_x (float): The starting point for the optimization.
        learning_rate (float): The step size for each update (alpha).
        momentum_coefficient (float): The momentum term (beta), typically between 0 and 1.
        num_iterations (int): The number of iterations to perform.

    Returns:
        tuple: A tuple containing:
            - x_history (list): List of x values at each iteration.
            - f_history (list): List of f(x) values at each iteration.
    """
    x = initial_x
    velocity = 0.0 # Initialize velocity (v) to zero

    x_history = [x]
    f_history = [f(x)]

    print(f"Starting Gradient Descent with Momentum from x = {initial_x}")
    print(f"Learning Rate (alpha): {learning_rate}")
    print(f"Momentum Coefficient (beta): {momentum_coefficient}\n")

    for _ in range(num_iterations):
        gradient = df(x)

        # Momentum update rule
        # v_k+1 = beta * v_k + (1 - beta) * gradient (or just gradient)
        # In this common form, it's often: v_k+1 = beta * v_k + learning_rate * gradient
        # Let's use the widely accepted form for velocity accumulation before subtraction
        velocity = momentum_coefficient * velocity + gradient

        # Update x
        x = x - learning_rate * velocity

        x_history.append(x)
        f_history.append(f(x))

    print(f"\nOptimization finished. Final x = {x:.6f}, Final f(x) = {f(x):.6f}")
    return x_history, f_history

# --- Parameters for optimization ---
initial_x_val = 7.0          # Starting point for x (try different values like 0.0, 2.0, -3.0)
learning_rate_val = 0.0065     # Step size (alpha)
momentum_coefficient_val = 0.8 # Momentum term (beta)
num_iterations_val = 35      # Number of steps

# --- Run the optimization ---
x_hist, f_hist = gradient_descent_with_momentum(
    initial_x_val,
    learning_rate_val,
    momentum_coefficient_val,
    num_iterations_val
)

# --- Plotting the results ---
plt.figure(figsize=(12, 6))

# Plot the function itself
x_vals = np.linspace(-3.5, 3.5, 500) # Range for plotting the function
y_vals = f(x_vals)
plt.plot(x_vals, y_vals, label='$f(x) = x^4 - 5x^2 - 3x$', color='blue', alpha=0.7)

# Plot the optimization path
plt.scatter(x_hist, f_hist, color='red', s=20, zorder=5, label='Optimization Path')
plt.plot(x_hist, f_hist, color='red', linestyle='--', linewidth=1, alpha=0.6)

# Highlight the starting and ending points
plt.scatter(x_hist[0], f_hist[0], color='green', s=100, marker='o', label='Start Point', zorder=6)
plt.scatter(x_hist[-1], f_hist[-1], color='purple', s=100, marker='X', label='End Point', zorder=6)

plt.title('Gradient Descent with Momentum for $f(x) = x^4 - 5x^2 - 3x$')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.grid(True, linestyle='--', alpha=0.6)
plt.legend()
plt.ylim(min(y_vals) - 5, max(y_vals) + 5) # Adjust y-limits for better visualization
plt.show()

# Print the final optimized value
print(f"\nOptimal x found: {x_hist[-1]:.6f}")
print(f"Minimum f(x) found: {f_hist[-1]:.6f}")

# Analytical global minimum:
# The function f(x) = x^4 - 5x^2 - 3x has two local minima.
# One is near x = -1.0 (f(x) approx -1.0)
# The other (global minimum) is near x = 1.8 (f(x) approx -10.0)
# You can try different initial_x_val to see which minimum the algorithm converges to.
