source('MSSP/src/modeling/k-fold-CV.R')


rstan_mixEff_lasso <- function(data, formula, location = 0, lambda, chains = 4, iter = 2000, refresh = 0){
  
  # Mixed Effect Lasso Bayesian Regression
  # ======
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # ======

  # Fit the model with the specified Laplace prior scale
  fit <- stan_glmer(formula, data = data, prior = laplace(location = location, scale = lambda, autoscale = FALSE), 
                    chains = chains, iter = iter, refresh = refresh)

  return(fit)
}

randomizedSearchCV <- function(data, formula, k_fold, MCMC_parms = NULL, location = 0, lambda_dist, ...){
  # Randomized Search K-Fold Validation
  # =====
  # MCMC_parms: list for controlling MCMC sampling method(chains, iter, refresh)
  # location: mean of the laplace prior
  # lambda_dist: distribution function that lambda is going to sample from
  # ... : named parameters of the lambda_dist:
  # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
  # =====
  # Return: <list> CV_summary 
  # CV_summary:
  ##  k-fold:
  ###   lambda: fit, lambda, 
  
  folds <- k_fold_CV(data = data, k = k_fold, random_k_fold = F)
  
  CV_summary <- list()
  
  # Randomized Search K-Fold Cross Validation
  for(k in 1:k_fold){ # run folds datasets
    params_value_vec <- do.call(lambda_dist, list(...))
    
    valid_df <- folds[[k]]
    train_df <- do.call(rbind, df_list[-k])
    
    k_summary <- list()
    index <- 1
    response <- strsplit(as.character(formula), "~")[[1]]
    for (lambda in params_value_vec){ # evaluate each lambda
      if (!is.null(MCMC_parms)){
        chains <- MCMC_parms[['chains']]
        iter <- MCMC_parms[['iter']]
        refresh <- MCMC_parms[['refresh']]  
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda, chains = chains, iter = iter, refresh = refresh)
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        valid_fitted <- predict(fit, newdata = valid_df)
        valid_residual <- valid_df[response] - valid_fitted
      }
      else{
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda)
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        valid_fitted <- predict(fit, newdata = valid_df)
        valid_residual <- valid_df[response] - valid_fitted        
      }
      
      model_summary <- list(k_fold = k, fit = fit, lambda = lambda, 
                            train_fitted = train_fitted, train_resid = train_resid,
                            valid_fitted = valid_fitted, valid_residual = valid_residual)
      
      k_summary[[index]] <- model_summary
      index <- index + 1
    }
    
    CV_summary[[paste0('fold',k)]] <- k_summary
  }
  
  return(CV_summary)
}



