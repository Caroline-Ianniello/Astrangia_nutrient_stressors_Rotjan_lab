
library(rstanarm)
library(ggplot2)
library(dplyr)
library(magrittr)
library(tidyr)

plot_mixeff_coef <- function(refit_model, quantile = TRUE, alpha = 0.05, title){
  # plot coeffecient estimation distribution
  # ===
  # quantile: <bool> TRUE to use a quantile interval, otherwise, standard error is used.
  # alpha: confidence level or quantile range (1 - alpha)
  # ===
  
  if(!quantile){ # standard error 
    print("Using Standard Error to calculate interval")
    var_name <- names(fixef(refit_model))
    coef_vec <- fixef(refit_model)
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
    var_name <- names(fixef(refit_model))
    n_var <- length(var_name)
    # interval <- posterior_interval(refit_model, prob = 1-alpha)
    # lower <- interval[1:n_var, 1]
    # upper <- interval[1:n_var, 2]
    
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

plot_coef_table <- function(table, title){
  # Plot the coefficient with different credible interval
  # ===
  ## table: <data.frame> the output estimation table from CoefEstTable script
  # ===
  
  # order for factor
  desired_order <- c(
    # Elevated NO3- Interactions
    "Elevated NO3-",
    "Elevated NO3- x 29°C",
    "Elevated NO3- x 29°C x Symbiotic",
    "Elevated NO3- x 29°C x Starved",
    "Elevated NO3- x 29°C x Starved x Symbiotic",
    "Elevated NO3- x 29°C x E. coli",
    "Elevated NO3- x 29°C x Symbiotic x E. coli",
    "Elevated NO3- x 29°C x Starved x E. coli",
    "Elevated NO3- x 29°C x Starved x Symbiotic x E. coli",
    
    # 29°C Interactions
    "29°C",
    "29°C x E. coli",
    "29°C x Symbiotic",
    "29°C x Symbiotic x E. coli",
    "29°C x Starved",
    "29°C x Starved x E. coli",
    "29°C x Starved x Symbiotic",
    "29°C x Starved x Symbiotic x E. coli",
    
    # Symbiotic and Starved Interactions
    "Symbiotic",
    "Elevated NO3- x Symbiotic",
    "Starved",
    "Elevated NO3- x Starved",
    "Starved x Symbiotic",
    "Elevated NO3- x Starved x Symbiotic",
    
    # E. coli Interactions
    "E. coli",
    "Symbiotic x E. coli",
    "Starved x E. coli",
    "Starved x Symbiotic x E. coli",
    "Elevated NO3- x E. coli",
    "Elevated NO3- x Symbiotic x E. coli",
    "Elevated NO3- x Starved x E. coli",
    "Elevated NO3- x Starved x Symbiotic x E. coli",
    
    # Intercept
    "INTERCEPT"
  )
  
  table <- table %>% mutate(label = factor(label, levels = rev(desired_order)))
  
  ggplot(table, aes(x = coef, y = label)) +
    # 95% Credible Interval
    geom_errorbar(aes(xmin = lower_95_CI, xmax = upper_95_CI), 
                  width = 0,          
                  color = "blue", 
                  size = 0.6,         
                  alpha = 1) +       
    # 90% Credible Interval
    geom_errorbar(aes(xmin = lower_90_CI, xmax = upper_90_CI), 
                  width = 0,          
                  color = "orange", 
                  size = 1.2,         
                  alpha = 1) +        
    # Estimation
    geom_point(size = 5, color = "black") + 
    geom_vline(xintercept = 0, linetype = "dashed", color = "red", size = 1) +
    theme_minimal() +
    labs(
      title = title,
      subtitle = "Estimation with 90% and 95% Credible Intervals",
      x = "Estimation",
      y = "Factors",
      caption = "Blue: 95% CI | Orange: 90% CI"
    ) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
      axis.title = element_text(face = "bold", size = 14), 
      axis.text.y = element_text(size = 12), #, angle = 0, hjust = 1
      axis.text.x = element_text(size = 12),
      legend.position = "none",                                   

    )

}
