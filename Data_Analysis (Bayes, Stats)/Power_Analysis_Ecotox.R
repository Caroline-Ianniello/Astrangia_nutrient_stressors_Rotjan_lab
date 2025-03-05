#Power analysis to solve for the appropriate sample size

library(pwr)

# Define known parameters
u <- 5  # Number of predictors (main effects only)
f2 <- 0.02  # Small effect size (adjust as needed)
sig.level <- 0.05  # Alpha level
power <- 0.80  # Desired power

# Solve for v (degrees of freedom)
result <- pwr.f2.test(u = u, v = NULL, f2 = f2, sig.level = sig.level, power = power)

# Compute required N
v_required <- ceiling(result$v)  # Round up degrees of freedom
N_required <- v_required + u + 1  # Solve for N

print(N_required)
