def objective_function(a,b,c,d):
    """
    Calculates the value of partial derviative the objective function.
    Returns:
        float: The value of the function at the given parameters.
    """
    return (a - 2)**2 + b**2 + (c + 2)**2 + (2*d)**2 - 5

def gradient_num (a,b,c,d):
    h = 7.8125e-3
    value = objective_function(a, b, c, d)
    term1 = 0.125*(value - objective_function(a - h, b, c, d))/h
    term2 = 0.125*(value - objective_function(a ,b - h, c, d))/h
    term3 = 0.125*(value - objective_function(a, b, c - h, d))/h
    term4 = 0.125*(value - objective_function(a ,b, c, d - h))/h

    return [term1, term2, term3, term4]

def gradient_ana (a,b,c,d):
    grad_a = 2 * (a - 2)
    grad_b = 2 * b
    grad_c = 2 * (c + 2)
    grad_d = 2 * (2 * d)
    return [grad_a, grad_b, grad_c, grad_d]


a_in = 0
b_in = 0 
c_in = 0
d_in = 0
for i in range (10):
    print([a_in,b_in,c_in,d_in])
    print(objective_function(a_in, b_in, c_in, d_in))
    print(gradient_num(a_in, b_in, c_in, d_in))
    print("\n")
    # print(gradient_ana(a_in, b_in, c_in, d_in))
    a_in += 10
    b_in += 10
    c_in += 10
    d_in += 10