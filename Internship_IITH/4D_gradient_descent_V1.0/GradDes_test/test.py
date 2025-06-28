import time 

def objective_function(a,b,c,d):
    """
    Calculates the value of the objective function.

    Args:
        params (np.array): A NumPy array containing the parameters [a, b, c, d].

    Returns:
        float: The value of the function at the given parameters.
    """
    return (a - 2)**2 + b**2 + (c + 2)**2 + (2*d)**2 - 5


a_in = 0
b_in = 0
c_in = 0
d_in = 0
for i in range (10):
    start = time.perf_counter()
    print(objective_function(a_in, b_in, c_in, d_in),[a_in, b_in, c_in, d_in])
    end = time.perf_counter()
    elapsed = end - start
    # print(f'Time taken: {elapsed:.6f} seconds')
    a_in += 1
    b_in += 1
    c_in += 1
    d_in += 1

# 3
# 4.75
# 10.0
# 18.75
# 31.0
# 46.75
# 66.0
# 88.75
# 115.0
# 144.75