# Initialize parameters
set.seed(42)
t_steps <- 30  # Reduced number of time steps for testing
n_classes <- 50  # Number of fitness classes
lambda <- 5      # Birth rate
r <- 0.1         # Mutation probability
p <- 0.75        # Probability of birth

# Initialize population and fitness levels
pop <- rep(10, n_classes)  # Initial population in each class
fitness <- seq(0, 1, length.out = n_classes)

# Initialize matrices for transitions
pop_history <- matrix(0, nrow = t_steps, ncol = n_classes)
pop_history[1, ] <- pop

# Simulation loop
for (t in 2:t_steps) {
  total_pop <- sum(pop)
  
  # Print progress every 50 steps
  if (t %% 50 == 0) {
    message("Time step: ", t, ", Total population: ", total_pop)
  }
  
  # Check if population is zero
  if (total_pop <= 0) {
    message("Population reached zero at time step: ", t)
    break
  }
  
  # Birth process
  births <- rbinom(1, total_pop, p)
  if (births > 0) {
    birth_probs <- ifelse(pop > 0, pop / total_pop, 0)  # Avoid division by zero
    if (sum(birth_probs) > 0) {  # Check for valid probabilities
      new_births <- sample(1:n_classes, births, prob = birth_probs, replace = TRUE)
      
      # Mutation process
      mutants <- runif(births) < r
      for (i in seq_along(new_births)) {
        if (mutants[i]) {
          new_births[i] <- sample(1:n_classes, 1)  # Assign random fitness class
        }
      }
      
      # Update population with births
      for (i in 1:n_classes) {
        pop[i] <- pop[i] + sum(new_births == i)
      }
    }
  }
  
  # Death process
  deaths <- rbinom(1, total_pop, 1 - p)
  if (deaths > 0) {
    death_probs <- ifelse(pop > 0, pop / total_pop, 0)  # Avoid division by zero
    if (sum(death_probs) > 0) {  # Check for valid probabilities
      death_classes <- sample(1:n_classes, deaths, prob = death_probs, replace = TRUE)
      for (i in 1:n_classes) {
        pop[i] <- max(0, pop[i] - sum(death_classes == i))
      }
    }
  }
  
  # Store population at current step
  pop_history[t, ] <- pop
  print(t)
}

# Prepare data for visualization
library(ggplot2)
library(tidyr)
pop_df <- as.data.frame(pop_history)
pop_df$Time <- 1:nrow(pop_df)
pop_df_long <- pivot_longer(pop_df, -Time, names_to = "Fitness_Class", values_to = "Population")
pop_df_long$Fitness_Class <- as.numeric(gsub("V", "", pop_df_long$Fitness_Class))

# Plot results
ggplot(pop_df_long, aes(x = Time, y = Population, fill = Fitness_Class)) +
  geom_area(position = "stack") +
  scale_fill_viridis_c(option = "C") +
  labs(
    title = "Population Dynamics by Fitness Class",
    x = "Time",
    y = "Population",
    fill = "Fitness Class"
  ) +
  theme_minimal()
