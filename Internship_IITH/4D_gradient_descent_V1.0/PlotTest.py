import numpy as np
import matplotlib.pyplot as plt

# Fixed parameters
epsilon_0 = 1.0
k = 1.0
time_steps = np.arange(0, 21) # From t=0 to t=20

# Different learning rates to test
alphas = [0.1,  # Slow decay
          0.8,  # Faster decay
          1.2,  # Oscillating decay
          2.0,  # Critical oscillation (constant magnitude)
          2.1,  # Divergence (oscillating and growing)
          2.5   # Stronger divergence
         ]

plt.figure(figsize=(12, 6))

# Plot 1: Error over Time
plt.subplot(1, 2, 1) # 1 row, 2 columns, first plot
for alpha in alphas:
    factor = (1 - alpha * k)
    epsilon_t = epsilon_0 * (factor)**time_steps
    plt.plot(time_steps, epsilon_t, label=f'α = {alpha}')

plt.title('Error $(\\epsilon_t)$ vs. Time $t$')
plt.xlabel('Time Step ($t$)')
plt.ylabel('Error $(\\epsilon_t)$')
plt.grid(True)
plt.axhline(0, color='gray', linestyle='--', linewidth=0.8) # Line at y=0
plt.legend()
plt.ylim(-5, 5) # Adjust y-limits to better see divergence

# Plot 2: Loss over Time
plt.subplot(1, 2, 2) # 1 row, 2 columns, second plot
for alpha in alphas:
    factor = (1 - alpha * k)
    loss_t = (epsilon_0 * (factor)**time_steps)**2
    plt.plot(time_steps, loss_t, label=f'α = {alpha}')

plt.title('Loss $(L_t)$ vs. Time $t$')
plt.xlabel('Time Step ($t$)')
plt.ylabel('Loss ($L_t$)')
plt.grid(True)
# plt.yscale('log') # Uncomment this if values get too large and you want to see them all
plt.legend()
plt.ylim(0, 20) # Adjust y-limits to better see initial divergence. If using log scale, remove this.


plt.tight_layout()
plt.show()