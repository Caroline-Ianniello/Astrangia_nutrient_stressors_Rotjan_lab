
library(rstanarm)
library(dplyr)
library(magrittr)
library(tidyr)
library(stringr)

tabulate_mixeff_coef <- function(refit_model, quantile = TRUE, alpha = c(0.05, 0.1)){
  # plot coefficient estimation distribution
  # ===
  # quantile: <bool> TRUE to use a quantile interval, otherwise, standard error is used.
  # alpha: a vector of confidence levels or quantile ranges (1 - alpha)
  # ===
  
  # Initialize variables
  var_name <- names(fixef(refit_model))
  n_var <- length(var_name)
  coef_vec <- fixef(refit_model)
  if (length(coef_vec) != n_var) stop("Length of Parameters estimated doesn't fit the numbers of fix effects")
  
  # Prepare the dataframe with variable and coef columns
  df <- data.frame(variable = var_name, coef = coef_vec)
  
  for (a in alpha) {
    if (!quantile) { # Standard error method
      
      print(paste("Using Standard Error to calculate interval for alpha =", a))
      se_vec <- se(refit_model)[1:n_var]
      
      # Determine the z-value based on alpha
      z <- if (a == 0.05) 1.96 else if (a == 0.01) 2.575 else if (a == 0.1) 1.645 else qnorm(1 - a / 2)
      
      # Calculate the confidence interval
      lower <- coef_vec - z * se_vec
      upper <- coef_vec + z * se_vec
      
      # Append new columns to the dataframe
      confidence_level <- as.character(100 - 100 * a)
      df[[paste0('lower_', confidence_level, '_CI')]] <- lower
      df[[paste0('upper_', confidence_level, '_CI')]] <- upper
      
    } else { # Quantile method
      
      print(paste("Calculating the quantile intervals (Credible Interval) for alpha =", a))
      
      # Posterior intervals (or credible intervals)
      interval <- data.frame(
        t(
          apply(as.matrix(refit_model), 2, function(x) quantile(x, c(a / 2, 0.5, 1 - (a / 2))))
        )
      )[1:n_var, ]
      
      colnames(interval) <- c('lower', 'coef', 'upper')
      
      # Append new columns to the dataframe
      credibility_level <- as.character(100 - 100 * a)
      df[[paste0('lower_', credibility_level, '_CI')]] <- interval$lower
      df[[paste0('upper_', credibility_level, '_CI')]] <- interval$upper
    }
    
    # Create a sign column for each alpha level
    df[[paste0('sign_', as.character(100 - 100 * a), '_CI')]] <- ifelse(df[[paste0('lower_', as.character(100 - 100 * a), '_CI')]] <= 0 & df[[paste0('upper_', as.character(100 - 100 * a), '_CI')]] >= 0, 
                                                                        paste0("0 in ", as.character(100 - 100 * a), "% CI"), 
                                                                        paste0("0 not in ", as.character(100 - 100 * a), "% CI"))
  }
  
  rownames(df) <- NULL
  
  # Rename Variable and reorder
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
  
  # Step 2: Map Original Variable Names to Descriptive Labels
  df_ordered <- df %>%
    mutate(
      label = variable %>%
        str_replace_all("dose_levelElevated", "Elevated NO3-") %>%
        str_replace_all("temp29", "29°C") %>%
        str_replace_all("feedStarved", "Starved") %>%
        str_replace_all("symbiontSymbiotic", "Symbiotic") %>%
        str_replace_all("e_coli1", "E. coli") %>%     
        str_replace_all("\\(Intercept\\)", "INTERCEPT") %>%  
        # Replace ":" with " x " for interactions
        str_replace_all(":", " x ")
    ) %>%
    mutate(
      label = factor(label, levels = desired_order)
    )
  
  return(df_ordered)
}


