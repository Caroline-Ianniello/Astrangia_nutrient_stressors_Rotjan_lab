if(!requireNamespace('rstanarm')){
  download.packages('rstanarm')
}

if(!requireNamespace('arm')){
  download.packages('arm')
}

library(arm)
library(rstanarm)



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

plot_leverage <- function(model) {
  plot(hatvalues(model),
       rstandard(model),
       xlab = "Leverage",
       ylab = "Standardized Residuals",
       main = "Residuals vs Leverage")
  abline(h = 0, col = "red")
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
