
library(rstanarm)
library(ggplot2)

plot_mixeff_coef <- function(refit_model, quantile = TRUE, alpha = 0.05, title){
  # plot coeffecient estimation distribution
  # ===
  # quantile: <bool> TRUE to use a quantile interval, otherwise, standard error is used.
  # alpha: confidence level or quantile range (1 - alpha)
  # ===
  
  if(!quantile){ # standard error 
    print("Using Standard Error to calculate interval")
    var_name <- names(coef(refit_model)[[1]])
    coef_vec <- unlist(coef(refit_model)[[1]])[1:length(var_name)]
    se_vec <- se(refit_model)[1:length(var_name)]
    
    if (alpha == .05){ # 95%
      z <- 1.96
    }
    else if(alpha == 0.01) { # 99%
      z <- 2.575
    }
    else if (alpha == 0.1) { # 90%
      z <- 1.645
    }
    
    df <- data.frame(variable = var_name, coef = coef_vec, se = se_vec)
    df$sign <- ifelse(df$coef - z * df$se > 0 | df$coef + z * df$se < 0, "0 in 95% CI", "0 not in 95% CI")
    
    ggplot(df, aes(y = variable, x = coef)) +
      geom_point(aes(color = sign)) +
      geom_errorbar(aes(xmin = coef + z * se, xmax = coef - z * se, color = sign), width = .2) +
      ggtitle(title) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
      theme_bw() +
      scale_color_manual(values = c("0 in 95% CI" = "orange", "0 not in 95% CI" = "blue")) +
      theme(legend.position = "none")
  }
  else {
    print("Calculating the quantile intervals")
    var_name <- names(coef(refit_model)[[1]])
    n_var <- length(var_name)
    interval <- posterior_interval(refit_model, prob = 1-alpha)
    lower <- interval[1:n_var, 1]
    upper <- interval[1:n_var, 2]
    
    df <- data.frame(t(apply(as.matrix(refit_model), 2, function(x) quantile(x, c(alpha/2, 0.5, 1 - (alpha/2))))))[1:n_var, ]
    colnames(df) <- c('lower', 'coef', 'upper')
    
    df <- df %>%
      mutate(variable = var_name,
             sign = ifelse(lower <= 0 & upper >= 0, "0 in 95% Quantile Interval", "0 not in 95% Quantile Interval"))
    
    ggplot(df, aes(y = variable, x = coef)) +
      geom_point(aes(color = sign)) +
      geom_errorbar(aes(xmin = lower, xmax = upper, color = sign), width = .2) +
      ggtitle(title) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
      theme_bw() +
      scale_color_manual(values = c("0 in 95% Quantile Interval" = "orange", "0 not in 95% Quantile Interval" = "blue")) +
      theme(legend.position = "none")
  }

}

# unit test
# plot_mixeff_coef(Nitrate_PAM_delta_lasso$BestRefit, title = '')

t(as.data.frame(apply(as.matrix(Nitrate_Resp_lasso$BestRefit), 2, function(x) quantile(x, c(0.05, 0.5, 0.975)))))

