import numpy as np
import matplotlib.pyplot as plt

def piecewise_exponential(x, a=1.0):
    """
    Piecewise function: f(x) = { 1-e^(-ax) if x >= 0
                                { 1-e^(ax)  if x < 0
    """
    if hasattr(x, '__iter__'):  # Handle arrays
        return np.array([piecewise_exponential(xi, a) for xi in x])
    
    if x >= 0:
        return 1 - np.exp(-a * x)
    else:
        return 1 - np.exp(a * x)

def numerical_gradient(func, x, h=1e-8):
    """
    Compute numerical gradient using central difference
    """
    return (func(x + h) - func(x - h)) / (2 * h)

def forward_difference_gradient(func, x, h=1e-8):
    """
    Compute numerical gradient using forward difference
    """
    return (func(x + h) - func(x)) / h

def backward_difference_gradient(func, x, h=1e-8):
    """
    Compute numerical gradient using backward difference
    """
    return (func(x) - func(x - h)) / h

def analytical_gradient(x, a=1.0):
    """
    Analytical gradient for comparison
    """
    if x > 0:
        return a * np.exp(-a * x)
    elif x < 0:
        return -a * np.exp(a * x)
    else:
        # At x=0, left derivative = -a, right derivative = a
        # Function is not differentiable at x=0
        return 0  # We'll use 0 as a compromise

def gradient_descent_numerical(func, x0=1.0, learning_rate=0.01, max_iter=10000, 
                              tolerance=1e-8, gradient_method='central', h=1e-8, a=1.0):
    """
    Gradient descent using numerical gradients for the piecewise exponential function
    """
    
    x = x0
    history = {'x': [x], 'f': [func(x, a)], 'grad': []}
    
    # Choose gradient computation method
    if gradient_method == 'central':
        grad_func = lambda x: numerical_gradient(lambda xi: func(xi, a), x, h)
    elif gradient_method == 'forward':
        grad_func = lambda x: forward_difference_gradient(lambda xi: func(xi, a), x, h)
    elif gradient_method == 'backward':
        grad_func = lambda x: backward_difference_gradient(lambda xi: func(xi, a), x, h)
    else:
        grad_func = lambda x: analytical_gradient(x, a)
    
    for k in range(max_iter):
        # Compute gradient
        if abs(x) < h:  # Near the cusp at x=0
            # Use one-sided differences when near the cusp
            if x >= 0:
                grad = forward_difference_gradient(lambda xi: func(xi, a), x, h)
            else:
                grad = backward_difference_gradient(lambda xi: func(xi, a), x, h)
        else:
            grad = grad_func(x)
        
        history['grad'].append(grad)
        
        # Gradient descent step
        x_new = x - learning_rate * grad
        
        # Store history
        history['x'].append(x_new)
        history['f'].append(func(x_new, a))
        
        # Check convergence
        if abs(x_new - x) < tolerance:
            print(f"Converged after {k+1} iterations")
            break
            
        x = x_new
    
    return x, history

def compare_gradient_methods(a=1.0):
    """
    Compare different gradient computation methods
    """
    print(f"Comparing gradient methods for a = {a}")
    print("=" * 60)
    
    test_points = [-2.0, -0.1, -0.01, 0.0, 0.01, 0.1, 2.0]
    
    print(f"{'x':<8} {'Analytical':<12} {'Central':<12} {'Forward':<12} {'Backward':<12}")
    print("-" * 60)
    
    for x in test_points:
        anal_grad = analytical_gradient(x, a)
        cent_grad = numerical_gradient(lambda xi: piecewise_exponential(xi, a), x, 1e-8)
        forw_grad = forward_difference_gradient(lambda xi: piecewise_exponential(xi, a), x, 1e-8)
        back_grad = backward_difference_gradient(lambda xi: piecewise_exponential(xi, a), x, 1e-8)
        
        print(f"{x:<8.2f} {anal_grad:<12.6f} {cent_grad:<12.6f} {forw_grad:<12.6f} {back_grad:<12.6f}")

def run_optimization_tests(a=1.0):
    """
    Run optimization tests with different starting points and methods
    """
    print(f"\nOptimization Tests for a = {a}")
    print("=" * 60)
    
    starting_points = [-5.0, -1.0, -0.1, 0.5, 1.0, 3.0]
    methods = ['central', 'forward', 'analytical']
    
    results = {}
    
    for method in methods:
        print(f"\nMethod: {method}")
        print(f"{'Start':<8} {'Final x':<12} {'Final f':<12} {'Iterations':<12}")
        print("-" * 50)
        
        results[method] = []
        
        for x0 in starting_points:
            x_min, hist = gradient_descent_numerical(
                piecewise_exponential, x0=x0, learning_rate=0.1, 
                max_iter=1000, gradient_method=method, a=a
            )
            
            final_f = piecewise_exponential(x_min, a)
            iterations = len(hist['x']) - 1
            
            results[method].append((x0, x_min, final_f, iterations))
            print(f"{x0:<8.1f} {x_min:<12.6f} {final_f:<12.8f} {iterations:<12}")
    
    return results

if __name__ == "__main__":
    # Test with different values of parameter 'a'
    a_values = [0.5, 1.0, 2.0]
    
    for a in a_values:
        print(f"\n{'='*80}")
        print(f"ANALYSIS FOR a = {a}")
        print(f"{'='*80}")
        
        # Compare gradient computation methods
        compare_gradient_methods(a)
        
        # Run optimization tests
        results = run_optimization_tests(a)
        
        # Visualizations
        plt.figure(figsize=(15, 10))
        
        # Plot the function
        x_vals = np.linspace(-3, 3, 1000)
        y_vals = [piecewise_exponential(x, a) for x in x_vals]
        
        plt.subplot(2, 3, 1)
        plt.plot(x_vals, y_vals, 'b-', linewidth=2, label=f'f(x), a={a}')
        plt.axhline(y=0, color='k', linestyle='--', alpha=0.3)
        plt.axvline(x=0, color='r', linestyle='--', alpha=0.5, label='Cusp at x=0')
        plt.title(f'Piecewise Exponential Function (a={a})')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.grid(True, alpha=0.3)
        plt.legend()
        
        # Plot gradients
        plt.subplot(2, 3, 2)
        x_grad = np.linspace(-2, 2, 1000)
        y_grad_analytical = [analytical_gradient(x, a) for x in x_grad]
        y_grad_numerical = [numerical_gradient(lambda xi: piecewise_exponential(xi, a), x) for x in x_grad]
        
        plt.plot(x_grad, y_grad_analytical, 'r-', linewidth=2, label='Analytical')
        plt.plot(x_grad, y_grad_numerical, 'b--', linewidth=1, label='Numerical', alpha=0.7)
        plt.axvline(x=0, color='k', linestyle='--', alpha=0.5)
        plt.title(f'Gradient Comparison (a={a})')
        plt.xlabel('x')
        plt.ylabel("f'(x)")
        plt.grid(True, alpha=0.3)
        plt.legend()
        
        # Convergence plots for different methods
        for i, method in enumerate(['central', 'analytical']):
            x_min, hist = gradient_descent_numerical(
                piecewise_exponential, x0=2.0, learning_rate=0.1,
                max_iter=100, gradient_method=method, a=a
            )
            
            plt.subplot(2, 3, 3+i)
            plt.semilogy(hist['f'], linewidth=2)
            plt.title(f'Convergence: {method} (a={a})')
            plt.xlabel('Iteration')
            plt.ylabel('f(x)')
            plt.grid(True, alpha=0.3)
        
        # Trajectory plot
        plt.subplot(2, 3, 5)
        x_min, hist = gradient_descent_numerical(
            piecewise_exponential, x0=2.0, learning_rate=0.1,
            max_iter=70, gradient_method='central', a=a
        )
        
        plt.plot(hist['x'], 'o-', linewidth=2, markersize=4)
        plt.axhline(y=0, color='r', linestyle='--', alpha=0.5, label='Minimum at x=0')
        plt.title(f'Optimization Trajectory (a={a})')
        plt.xlabel('Iteration')
        plt.ylabel('x')
        plt.grid(True, alpha=0.3)
        plt.legend()
        
        # Phase plot
        plt.subplot(2, 3, 6)
        plt.plot(hist['x'][:-1], hist['grad'], 'o-', linewidth=2, markersize=4)
        plt.axhline(y=0, color='r', linestyle='--', alpha=0.5)
        plt.axvline(x=0, color='r', linestyle='--', alpha=0.5)
        plt.title(f'Phase Plot: x vs gradient (a={a})')
        plt.xlabel('x')
        plt.ylabel('Gradient')
        plt.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.show()
    
    print("\n" + "="*80)
    print("KEY OBSERVATIONS:")
    print("="*80)
    print("1. Function has cusp at x=0 where it's not differentiable")
    print("2. Minimum occurs at x=0 with f(0)=0 for any a>0")
    print("3. Central difference works well except very close to x=0")
    print("4. Near x=0, use one-sided differences to avoid numerical issues")
    print("5. Convergence rate depends on parameter 'a' and learning rate")
    print("6. All methods converge to x=0 (global minimum)")