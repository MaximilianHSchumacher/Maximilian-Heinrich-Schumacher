library(haven)
library(dplyr)
library(writexl)
library(ggplot2)
library(plm)

############################################ load data and overview ########################################

fatality <- read_dta("Assignment3/Data/fatality.dta")

glimpse(fatality)
summary(fatality)
head(fatality)

# Simple scatterplot in R
plot(fatality$beertax, fatality$spircons,
     main = "Traffic Fatality Rate vs. Beer Tax",
     xlab = "Beer Tax Rate",
     ylab = "Traffic Fatality Rate",
     pch = 19, col = "darkblue")
abline(lm(spircons ~ beertax, data = fatality), col = "red", lwd = 2)

############################################ within-state-variation ########################################
# Load necessary library
# Group by state and calculate SD over time
within_sd <- fatality %>%
  group_by(state) %>%
  summarise(
    sd_spircons = sd(spircons, na.rm = TRUE),
    sd_beertax = sd(beertax, na.rm = TRUE)
  )

# Calculate overall SD for comparison
overall_sd_spircons <- sd(fatality$spircons, na.rm = TRUE)
overall_sd_beertax <- sd(fatality$beertax, na.rm = TRUE)

# Print results
print(within_sd)

cat("Overall SD of spircons:", overall_sd_spircons, "\n")
cat("Overall SD of beertax:", overall_sd_beertax, "\n")

# Optional: summarize average within-state variability
within_sd_summary <- within_sd %>%
  summarise(
    avg_sd_spircons = mean(sd_spircons),
    avg_sd_beertax = mean(sd_beertax)
  )

print(within_sd_summary)


############################################ average per state/ year ########################################

# Average spircons per year (across all states)
avg_by_year <- fatality %>%
  group_by(year) %>%
  summarise(avg_spircons = mean(spircons, na.rm = TRUE))

print(avg_by_year)

# Average spircons per state (across all years)
avg_by_state <- fatality %>%
  group_by(state) %>%
  summarise(avg_spircons = mean(spircons, na.rm = TRUE))

print(avg_by_state)

############################################ plot fertility rate by beer tax ########################################

# Load necessary package
library(ggplot2)

# Create the faceted scatterplot
ggplot(fatality, aes(x = beertax, y = spircons)) +
  geom_point(color = "darkblue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  facet_wrap(~ year) +
  labs(
    title = "Traffic Fatality Rate vs. Beer Tax by Year",
    x = "Beer Tax Rate",
    y = "Traffic Fatality Rate"
  ) +
  theme_minimal()



##################################################Regress the traffic-fatality rate on the beer-tax rate, and add the predicted traffic-fatality rate to the scatterplot.################### 

model <- lm(spircons ~ beertax, data = fatality)

# Add predicted values to the dataset
fatality$predicted_spircons <- predict(model)

# Plot observed data and regression line (predicted values)
ggplot(fatality, aes(x = beertax, y = spircons)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  geom_line(aes(y = predicted_spircons), color = "red", size = 1) +
  labs(
    title = "Regression: Traffic Fatality Rate on Beer Tax",
    x = "Beer Tax Rate",
    y = "Traffic Fatality Rate"
  ) +
  theme_minimal()


############################################### mean-diff.################### 

# Load dplyr if not already


# Mean-difference spircons and beertax by state
fatality_md <- fatality %>%
  group_by(state) %>%
  mutate(
    mean_spircons = mean(spircons, na.rm = TRUE),
    mean_beertax = mean(beertax, na.rm = TRUE),
    md_spircons = spircons - mean_spircons,
    md_beertax = beertax - mean_beertax
  ) %>%
  ungroup()
# View the first few rows with mean-differenced variables
fatality_md %>%
  select(state, year, spircons, beertax, md_spircons, md_beertax) %>%
  arrange(state, year) %>%
  head(10)  # adjust number as needed

####################################### 7.################################

# Plot: Mean-differenced traffic fatality rate vs. beer tax
ggplot(fatality_md, aes(x = md_beertax, y = md_spircons)) +
  geom_point(color = "darkblue", alpha = 0.7) +
  labs(
    title = "Mean-Differenced Traffic Fatality Rate vs. Beer Tax",
    x = "Mean-Differenced Beer Tax",
    y = "Mean-Differenced Fatality Rate"
  ) +
  theme_minimal()
####################################### 8.################################

# Run the mean-differenced regression
model_md <- lm(md_spircons ~ md_beertax, data = fatality_md)

# Add predicted values to the dataset
fatality_md$predicted_md_spircons <- predict(model_md)

# Plot with regression line
ggplot(fatality_md, aes(x = md_beertax, y = md_spircons)) +
  geom_point(color = "darkblue", alpha = 0.7) +
  geom_line(aes(y = predicted_md_spircons), color = "red", size = 1) +
  labs(
    title = "Mean-Differenced Regression: Fatality Rate on Beer Tax",
    x = "Mean-Differenced Beer Tax",
    y = "Mean-Differenced Fatality Rate"
  ) +
  theme_minimal()

summary(model_md)

####################################### 9.################################


# Convert the data to a panel data frame
fatality_panel <- pdata.frame(fatality, index = c("state", "year"))

# Estimate the fixed effects model (within estimator)
fe_model <- plm(spircons ~ beertax, data = fatality_panel, model = "within")

# Reload the clean dataset
fatality <- read_dta("/Users/felixsattler/Downloads/fatality.dta")

# First-differencing, fresh and isolated
fatality_fd <- fatality %>%
  filter(state == 1) %>%
  mutate(
    fd_spircons = format(fd_spircons, digits = 5, nsmall = 5),
    fd_beertax = format(fd_beertax, digits = 5, nsmall = 5)
  ) %>%
  select(year, spircons, fd_spircons, beertax, fd_beertax)

# Check the result
fatality_fd %>%
  filter(state == 1) %>%
  select(year, spircons, fd_spircons, beertax, fd_beertax)

####################################### 14.################################

# Schritt 15: Regression mit first-differenced Daten
model_fd <- lm(fd_spircons ~ fd_beertax, data = fatality_fd)

# Vorhergesagte Werte hinzufügen
fatality_fd$predicted_fd_spircons <- predict(model_fd)

# Scatterplot mit Regressionslinie (vorhergesagte Werte)


ggplot(fatality_fd, aes(x = fd_beertax, y = fd_spircons)) +
  geom_point(color = "darkblue", alpha = 0.7) +
  geom_line(aes(y = predicted_fd_spircons), color = "red", size = 1) +
  labs(
    title = "First-Differenced Regression: Fatality Rate on Beer Tax",
    x = "First-Differenced Beer Tax",
    y = "First-Differenced Fatality Rate"
  ) +
  theme_minimal()

####################################### 15.################################

# Nur Beobachtungen mit gültigen Differenzen
fatality_fd_clean <- fatality_fd %>%
  filter(!is.na(fd_spircons) & !is.na(fd_beertax))
model_fd <- lm(fd_spircons ~ fd_beertax, data = fatality_fd_clean)
fatality_fd_clean$predicted_fd_spircons <- predict(model_fd)

ggplot(fatality_fd_clean, aes(x = fd_beertax, y = fd_spircons)) +
  geom_point(color = "darkblue", alpha = 0.7) +
  geom_line(aes(y = predicted_fd_spircons), color = "red", size = 1) +
  labs(
    title = "First-Differenced Regression: Fatality Rate on Beer Tax",
    x = "First-Differenced Beer Tax",
    y = "First-Differenced Fatality Rate"
  ) +
  theme_minimal()
summary(model_fd)

