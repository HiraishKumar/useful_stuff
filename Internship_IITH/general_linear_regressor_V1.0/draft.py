import time

def gradient_func(x):
    h = 1e-5
    ans = (func(x+h) - func(x-h)) / (2*h)
    return ans

def func(x):
    return ((x)**2 + 4*x - 1)

def gradient_descent(initial_x, learning_rate, num_iterations):
    x = initial_x
    x_at_min = initial_x
    y_min = func(x)

    for _ in range(num_iterations):
        gradient = gradient_func(x)
        y = func(x)
        x_diff = learning_rate * gradient
        if y <= y_min:
            y_min = y
            x_at_min = x
        x = x - x_diff
    return int(x_at_min),int(y_min)

start_time = time.perf_counter() 
result = gradient_descent(2400, 0.5, 30)
end_time = time.perf_counter()

elapsed_time_ns = (end_time - start_time) * 1_000_000_000 
elapsed_time_ms = elapsed_time_ns / 1_000_000 

print(f"Result: {result}")
print(f"Execution time: {elapsed_time_ns:.2f} nanoseconds")