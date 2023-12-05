
library(rstanarm)
library(ggplot2)

plot_mixeff_coef <- function(refit_model, title){
  
  var_name <- names(coef(refit_model)[[1]])
  coef_vec <- unlist(coef(refit_model)[[1]])[1:length(var_name)]
  se_vec <- se(refit_model)[1:length(var_name)]
  
  df <- data.frame(variable = var_name, coef = coef_vec, se = se_vec)
  df$sign <- ifelse(df$coef - 1.96 * df$se > 0 | df$coef + 1.96 * df$se < 0, "0 in 95% CI", "0 not in 95% CI")
  
  ggplot(df, aes(y = variable, x = coef)) +
    geom_point(aes(color = sign)) +
    geom_errorbar(aes(xmin = coef + 1.96 * se, xmax = coef - 1.96 * se, color = sign), width = .2) +
    ggtitle(title) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
    theme_bw() +
    scale_color_manual(values = c("0 in 95% CI" = "black", "0 not in 95% CI" = "blue")) +
    theme(legend.position = "none")
}

# unit test
# plot_mixeff_coef(Nitrate_PAM_delta_lasso$BestRefit, title = '')
