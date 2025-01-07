if(!requireNamespace('rstanarm')){
  download.packages('rstanarm')
}

if(!requireNamespace('arm')){
  download.packages('arm')
}

library(arm)
library(rstanarm)


# Sum of squared error ----------------------------------------------------

calculate_SSE <- function(actual, prediction){
  return(sum((actual-prediction)^2))
}

# Statistical information about the residuals -----------------------------


evaluate_residuals <- function(model) {
  residuals_info <- summary(resid(model))
  return(residuals_info)
}


# fitted ~ resid plot -----------------------------------------------------

plot_residuals <- function(model) {
  plot(resid(model) ~ fitted(model),
       xlab = "Fitted Values",
       ylab = "Residuals",
       main = "Residuals vs Fitted")
  abline(h = 0, col = "red")
}


# identify influential outliers -------------------------------------------

standirized_resid <- function(model) {
  # Check if the model is a stanreg object
  if (!inherits(model, "stanreg")) {
    stop("Model must be a 'stanreg' object.")
  }

  # Use posterior_predict to get predictions
  y_pred <- posterior_predict(model)

  # Calculate standardized residuals
  residuals <- residuals(model)
  std_residuals <- residuals / sd(residuals)

  data_for_plot <- data.frame(Index = 1:length(std_residuals), Std_Residuals = std_residuals)

  # Create the ggplot
  ggplot(data_for_plot, aes(x = Index, y = Std_Residuals)) +
    geom_hline(yintercept = 0, color = "red") +
    geom_point(alpha = 0.5) +
    labs(x = "Index", y = "Standardized Residuals", title = "Standardized Residuals Plot") +
    theme_minimal()
}

#  qqplot -----------------------------------------------------------------

plot_qq <- function(model) {
  qqnorm(resid(model))
  qqline(resid(model), col = "red")
}


# binned residual plot ----------------------------------------------------

plot_binned_residuals <- function(model) {

  binnedplot(fitted(model), resid(model),
             xlab = "Fitted values",
             ylab = "Residuals",
             main = "Binned Residual Plot")
}
