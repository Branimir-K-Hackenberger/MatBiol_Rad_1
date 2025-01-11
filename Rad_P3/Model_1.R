# Početne postavke
set.seed(123)
time_steps <- 100  # Broj vremenskih koraka
population <- data.frame(
  stage = c("kokoni", "mladi", "zreli", "revertanti"),
  count = c(100, 0, 0, 0)  # Početne populacije
)

# Parametri
transition_rates <- list(
  kokoni_to_mladi = 0.1,
  mladi_to_zreli = 0.2,
  zreli_to_revertanti = 0.05,
  mortalitet = c(kokoni = 0.01, mladi = 0.02, zreli = 0.03, revertanti = 0.04)
)

# Simulacija
results <- list()
results[[1]] <- population

for (t in 2:time_steps) {
  prev_population <- results[[t - 1]]
  next_population <- prev_population
  
  # Prijelaz iz kokona u mlade
  transitioning_kokoni <- rbinom(1, prev_population$count[1], transition_rates$kokoni_to_mladi)
  next_population$count[1] <- next_population$count[1] - transitioning_kokoni
  next_population$count[2] <- next_population$count[2] + transitioning_kokoni
  
  # Prijelaz iz mladih u zrele
  transitioning_mladi <- rbinom(1, prev_population$count[2], transition_rates$mladi_to_zreli)
  next_population$count[2] <- next_population$count[2] - transitioning_mladi
  next_population$count[3] <- next_population$count[3] + transitioning_mladi
  
  # Prijelaz iz zrelih u revertante
  transitioning_zreli <- rbinom(1, prev_population$count[3], transition_rates$zreli_to_revertanti)
  next_population$count[3] <- next_population$count[3] - transitioning_zreli
  next_population$count[4] <- next_population$count[4] + transitioning_zreli
  
  # Mortalitet
  next_population$count <- next_population$count - 
    rbinom(4, prev_population$count, transition_rates$mortalitet)
  
  # Spremljena populacija za trenutni korak
  next_population$count[next_population$count < 0] <- 0  # Izbjegavanje negativnih vrijednosti
  results[[t]] <- next_population
}

# Vizualizacija rezultata
library(ggplot2)
df <- do.call(rbind, lapply(1:time_steps, function(i) {
  cbind(step = i, results[[i]])
}))
ggplot(df, aes(x = step, y = count, color = stage)) +
  geom_line() +
  labs(title = "Simulacija populacije gujavica", x = "Vremenski koraci", y = "Broj jedinki") +
  theme_minimal()

