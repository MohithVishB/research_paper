library(ggplot2)
library(dplyr)
library(tidyr)
library(car)
library(reshape2)

wine_data <- read.csv("data/winequality-red.csv", sep = ";")

options(repr.plot.width = 18,  # wider than before
        repr.plot.height = 10)

long_data <- wine_data %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "value")

# Plot histograms for all variables
ggplot(long_data, aes(x = value)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black") +
  facet_wrap(~ variable, scales = "free", ncol = 4) +
  theme_minimal(base_size = 20) +
  labs(
    title = "Distribution of All Variables in Wine Dataset",
    x = "Value",
    y = "Count"
  )
summary(wine_data)
sum(is.na(wine_data))

options(repr.plot.width = 15, repr.plot.height = 10)

predictors <- select(wine_data, alcohol, chlorides, citric.acid, density,
                     fixed.acidity, free.sulfur.dioxide, pH, residual.sugar,
                     sulphates, total.sulfur.dioxide, volatile.acidity)

long_data <- predictors %>%
  mutate(quality = wine_data$quality) %>%
  pivot_longer(cols = -quality, names_to = "variable", values_to = "value") %>%
  group_by(variable) %>%
  mutate(value_bin = cut(value, breaks = 6)) %>%
  ungroup()

ggplot(long_data, aes(x = value_bin, y = quality)) +
  geom_boxplot(outlier.size = 0.5) +
  facet_wrap(~ variable, scales = "free_x", ncol = 4) +
  labs(
    x = "",
    y = "Quality",
    title = "Boxplots of Quality Across Binned Predictor Values"
  ) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


lm_model <- lm(quality ~ . - fixed.acidity, data = wine_data)
backward_model <- step(lm_model, direction = "backward")
null_model <- lm(quality ~ 1, data = wine_data)
scope <- formula(lm_model)
forward_model <- step(null_model, scope = scope, direction = "forward")

summary(forward_model)
summary(backward_model)

options(repr.plot.width = 12, repr.plot.height = 6)
final_model <- forward_model

ggplot(data = data.frame(fitted = final_model$fitted.values,
                         resid  = resid(final_model)),
       aes(x = fitted, y = resid)) +
  geom_point(alpha = 0.2, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted Values",
       x = "Fitted Values",
       y = "Residuals") +
  theme_minimal(base_size = 20)

residuals_df <- data.frame(res = resid(forward_model))

ggplot(residuals_df, aes(sample = res)) +
  stat_qq() +
  stat_qq_line(color = "red", linewidth = 1) +
  labs(
    title = "QQ Plot of Residuals",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal(base_size = 20)

summary(final_model)

# Select predictors
options(repr.plot.width = 11, repr.plot.height = 11)

predictors <- wine_data %>%
  select(alcohol, chlorides, citric.acid, density,free.sulfur.dioxide, pH, residual.sugar, sulphates, total.sulfur.dioxide, volatile.acidity)

# Create correlation matrix and melt it
corr_matrix_wine <- cor(predictors, use = "complete.obs") %>%
  melt(varnames = c("var1", "var2"), value.name = "corr")

# Plot
plot_corr_matrix_wine <- 
  corr_matrix_wine %>%
  ggplot(aes(x = var1, y = var2)) +
  geom_tile(aes(fill = corr), color = "white") +
  scale_fill_distiller(
    "Correlation Coefficient\n",
    palette = "YlOrRd",
    direction = 1,
    limits = c(-1, 1)
  ) +
  labs(title = "Correlation Matrix of Selected Wine Predictors", x = "", y = "") +
  theme_minimal(base_size = 20) +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, size = 14, hjust = 1),
    axis.text.y = element_text(vjust = 1, size = 14, hjust = 1),
    legend.title = element_text(size = 18),
    legend.text = element_text(size = 12),
    legend.key.size = unit(1.5, "cm")
  ) +
  coord_fixed() +
  geom_text(aes(label = round(corr, 2)), color = "black", size = 6)

# Show the plot
plot_corr_matrix_wine

vif(final_model)
