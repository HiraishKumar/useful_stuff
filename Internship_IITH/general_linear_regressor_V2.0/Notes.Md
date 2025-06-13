The Adam (Adaptive Moment Estimation) optimization algorithm iteratively updates parameters to minimize a function. Given a function f(x) and its gradient ∇f(x), the update rules for a single parameter x at iteration t are as follows:

1. Initialization:

    Initial parameter value: x0​

    Learning rate: α (often denoted as learning_rate in code)

    Exponential decay rates for moment estimates: β1​, β2​

    Small constant for numerical stability: ϵ

    Initialize first moment vector: m0​=0

    Initialize second moment vector: v0​=0

2. Iteration (for t = 1, 2, \dots, \text{num_iterations}):

    Compute the gradient:

    gt​=∇f(xt−1​)

    Update biased first moment estimate (mean of gradients):

    mt​=β1​⋅mt−1​+(1−β1​)⋅gt​

    Update biased second moment estimate (uncentered variance of gradients):

    vt​=β2​⋅vt−1​+(1−β2​)⋅gt2​

    Compute bias-corrected first moment estimate:

    m^t​=1−β1t​mt​​

    Compute bias-corrected second moment estimate:

    v^t​=1−β2t​vt​​

    Update parameters:

    xt​=xt−1​−α⋅v^t​
    ​+ϵm^t​​

Where:

    xt​ is the parameter value at iteration t.

    gt​ is the gradient of the objective function with respect to the parameter x at iteration t.

    mt​ is the exponentially decaying average of past gradients.

    vt​ is the exponentially decaying average of past squared gradients.

    m^t​ and v^t​ are the bias-corrected estimates of the first and second moments, respectively, which help to mitigate the bias towards zero that occurs in the early steps due to initialization.