# Parameters
n_states <- 3  # Number of states (Cocoons, Juveniles, Adults)
n_steps <- 200  # Simulation steps
initial_population <- c(C = 100, J = 50, A = 20)  # Initial population

# Transition matrix
P <- matrix(c(
  0.7, 0.2, 0.0,  # Cocoons to Juveniles
  0.0, 0.6, 0.3,  # Juveniles to Adults
  0.0, 0.0, 1.0   # Adults to survival
), nrow = n_states, byrow = TRUE)

# Normalize transition matrix
P <- sweep(P, 1, rowSums(P), FUN = "/")

# Adjust fitness contributions for soil management
pH_effect <- exp(-2 * abs(7 - 6.5))  # Moderate pH effect
moisture_effect <- exp(-5 * (0.3 - 0.35)^2)  # Stronger moisture effect
nutrient_effect <- 100  # Much larger nutrient effect

# Combined environmental fitness factor
fitness_factor <- pH_effect * moisture_effect * nutrient_effect
print(fitness_factor)  # Debugging fitness factor

# Scale specific transitions by fitness factor
modified_P <- P
modified_P[1, 2] <- P[1, 2] * fitness_factor  # Cocoons to Juveniles
modified_P[2, 3] <- P[2, 3] * fitness_factor  # Juveniles to Adults
modified_P[3, 3] <- P[3, 3] * fitness_factor  # Adult survival

# Re-normalize rows to ensure valid probabilities
modified_P <- sweep(modified_P, 1, rowSums(modified_P), FUN = "/")
print(modified_P)  # Debugging final modified matrix

# Initialize population matrices
baseline_population <- matrix(0, nrow = n_steps, ncol = n_states)
colnames(baseline_population) <- c("C", "J", "A")
baseline_population[1, ] <- initial_population

managed_population <- matrix(0, nrow = n_steps, ncol = n_states)
colnames(managed_population) <- c("C", "J", "A")
managed_population[1, ] <- initial_population

# Baseline simulation (no soil management)
for (t in 2:n_steps) {
  baseline_population[t, ] <- baseline_population[t - 1, ] %*% P
}

# Managed simulation (with soil management)
for (t in 2:n_steps) {
  managed_population[t, ] <- managed_population[t - 1, ] %*% modified_P
}

# Plot baseline vs managed population
plot(1:n_steps, rowSums(baseline_population), type = "l", col = "red",
     xlab = "Time Steps", ylab = "Total Population",
     main = "Impact of Soil Management on Earthworm Population")
lines(1:n_steps, rowSums(managed_population), col = "blue", lty = 2)
legend("topright", legend = c("Baseline", "With Management"),
       col = c("red", "blue"), lty = c(1, 2))

# Calculate and plot differences
population_diff <- rowSums(managed_population) - rowSums(baseline_population)
plot(1:n_steps, population_diff, type = "l", col = "green",
     xlab = "Time Steps", ylab = "Population Difference",
     main = "Difference Between Baseline and Management")
