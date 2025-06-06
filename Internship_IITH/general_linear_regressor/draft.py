def gradient_func(x):
    h = 1e-5
    ans = (func(x+h) - func(x-h)) / (2*h)
    # print (f'Gradient: {ans}')
    return ans

def func(x):
    return ((x)**2 + 4*x - 1)

def gradient_descent(initial_x, learning_rate, num_iterations):

    x        = initial_x
    x_at_min = initial_x
    y_min    = func(x)


    for _ in range(num_iterations):
        gradient = gradient_func(x)
        # print(f"X_init: {x}")
        y = func(x)
        # print(f"Y val : {y}")
        x_diff = learning_rate * gradient
        # print(f"X_Diff: {x_diff}")
        if y <= y_min:
            y_min = y
            x_at_min = x
        x = x - x_diff
        # print(f"X_new: {x}")

    return int(x_at_min),int(y_min)

print(gradient_descent(2400,0.5,3))