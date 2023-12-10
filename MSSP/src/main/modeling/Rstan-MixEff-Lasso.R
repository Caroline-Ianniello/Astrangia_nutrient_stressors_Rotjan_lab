source('MSSP/src/main/modeling/KFold-CV.R')
library(rstan)
library(rstanarm)

set.MC.cores <- function(cores = 4){
  # Specify number of cores for MCMC 
  # ===
  # cores: <int> numbers of cores, if set to -1 then take all resources
  ## Don't set to -1 if you are working on cloud computing clusters.
  # ===
  # return: void
  if (cores != -1){
    options(mc.cores = 4)
  }
  else{
    options(mc.cores = parallel::detectCores())
  }
}

rstan_mixEff_lasso <- function(data, formula, location = 0, lambda, chains = 4, iter = 2000, refresh = 0, adapt_delta = NULL, QR = FALSE, sparse = FALSE){
  
  # Mixed Effect Lasso Bayesian Regression
  # ===
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # adapt_delta: <float> specify the  target average proposal acceptance probability during Stan's adaptation period. (when using HMC)
  # QR: <bool> if TRUE applies a scaled qr decomposition to the design matrix
  # sparse: <bool> A logical scalar (defaulting to FALSE) indicating whether to use a sparse representation of the design (X) matrix. 
  ## It is not possible to specify both QR = TRUE and sparse = TRUE.
  # ===

  # Fit the model with the specified Laplace prior scale
  fit <- stan_glmer(formula, data = data, family = gaussian(), 
                    prior = laplace(location = location, scale = lambda, autoscale = FALSE), 
                    prior_covariance = decov(),
                    chains = chains, iter = iter, refresh = refresh,
                    adapt_delta = adapt_delta, QR = QR, sparse = sparse)

  return(fit)
}

customizedRandomizedSearchCV <- function(data, formula, fold_number, stratified_target, MCMC_parms = NULL, randomseed = NULL, lambda_dist, ...){
  # Randomized Search K-Fold Validation Applying Customized K-Fold CV
  # =====
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # fold_number: <int> number k for k-fold CV.
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh, adapt_delta, QR, sparse)
  # location: <int/float> mean of the laplace prior
  # lambda_dist: <callable distribution function> distribution function that lambda is going to sample from
  # ... : named parameters of the lambda_dist:
  # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
  # =====
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # =====
  #          | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lamba_1  |       |       |       |       |
  # lamba_2  |       |       |       |       |
  # lamba_3  |       |       |       |       |
  # lamba_4  |       |       |       |       |
  # ...      |       |       |       |       |
  # lambda_p |       |       |       |       |

  
  folds_info <- customized_stratified_kfold_CV(data = data, k = fold_number, stratified_target = stratified_target)
  
  if(is.null(randomseed)){
    params_value_vec <- do.call(lambda_dist, list(...))
  }
  else{
    set.seed(randomseed)
    params_value_vec <- do.call(lambda_dist, list(...))
  }
  
  n_lambda <- length(params_value_vec)
  
  MSE_array <- array(NA, dim = c(n_lambda, fold_number, 2), dimnames = list(params_value_vec, paste0('fold', c(1:5)), c('train', 'valid'))) # third dimension is to store both MSE of training data and validation data.
  
  response <- strsplit(as.character(formula), "~")[[2]]

  isolated_df <- folds_info[["isolated"]]
  
  for(l in 1:n_lambda){ # loop over each lambda candidates
    lambda <- params_value_vec[l]
    
    # summary for each lambda
    L_summary <- list()
    
    for(k in 1:fold_number){ # loop over each fold
      
      # normal k-fold process
      folds <- folds_info[["Folds"]]
      valid_df <- folds[[k]]
      train <- do.call(rbind, folds[-k])
      
      # concatenate the datasets that contains not enough observation for a specific genetID to be included in CV.

      train_df <- rbind(isolated_df, train)
      
      index <- 1
      
      if (!is.null(MCMC_parms)){ # arguments of MCMC params have been passed to the function
        
        # override MCMC settings
        chains <- MCMC_parms[['chains']]
        iter <- MCMC_parms[['iter']]
        refresh <- MCMC_parms[['refresh']]
        adapt_delta <- MCMC_parms[['adapt_delta']]
        QR <- MCMC_parms[['QR']]
        sparse <- MCMC_parms[['sparse']]
        
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda, chains = chains, iter = iter, refresh = refresh, adapt_delta = adapt_delta, QR = QR, sparse = sparse)
        
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        # calculate MSE for train data
        MSE_train <- sum(train_resid^2) / length(train_resid)
        MSE_array[l,k,1] <- MSE_train
        
        valid_fitted <- posterior_predict(fit, newdata = valid_df) # we use posterior predict when we apply a Bayesian Regression
        valid_resid <- valid_fitted - valid_df[[response]]
        # calculate MSE for validation data
        MSE_valid <- sum(valid_resid^2) / length(valid_resid)
        MSE_array[l,k,2] <- MSE_valid
        
      }
      else{ # MCMC by default (refresh = 0)
        
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda)
        
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        # calculate MSE for train data
        MSE_train <- sum(train_resid^2) / length(train_resid)
        MSE_array[l,k,1] <- MSE_train
        
        valid_fitted <- posterior_predict(fit, newdata = valid_df) # we use posterior predict when we apply a Bayesian Regression
        valid_resid <- valid_fitted - valid_df[[response]]
        # calculate MSE for validation data
        MSE_valid <- sum(valid_resid^2) / length(valid_resid)
        MSE_array[l,k,2] <- MSE_valid
      }

    }
    
  }
  
  return(MSE_array)
}

customizedGridSearchCV <- function(data, formula, fold_number, stratified_target, params_vec, MCMC_parms = NULL){
  # Grid Search K-Fold Validation Applying Customized K-Fold CV
  # =====
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # fold_number: <int> number k for k-fold CV.
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh)
  # params_vec: Since we are only tuning the parameter "lambda" of laplace distribution, simplifying the program by giving a vector.
  # =====
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # =====
  #           | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lambda_1  |       |       |       |       |
  # lambda_2  |       |       |       |       |
  # lambda_3  |       |       |       |       |
  # lambda_4  |       |       |       |       |
  # ...       |       |       |       |       |
  # lambda_p  |       |       |       |       |

  
  folds_info <- customized_stratified_kfold_CV(data = data, k = fold_number, stratified_target = stratified_target)
  
  n_lambda <- length(params_vec)
  
  MSE_array <- array(NA, dim = c(n_lambda, fold_number, 2), dimnames = list(params_vec, paste0('fold', c(1:5)), c('train', 'valid'))) # third dimension is to store both MSE of training data and validation data.
  
  response <- strsplit(as.character(formula), "~")[[2]]

  isolated_df <- folds_info[["isolated"]]
  
  for(l in 1:n_lambda){ # loop over each lambda candidates
    lambda <- params_vec[l]
    
    # summary for each lambda
    L_summary <- list()
    
    for(k in 1:fold_number){ # loop over each fold
      
      # normal k-fold process
      folds <- folds_info[["Folds"]]
      valid_df <- folds[[k]]
      train <- do.call(rbind, folds[-k])
      
      # concatenate the datasets that contains not enough observation for a specific genetID to be included in CV.

      train_df <- rbind(isolated_df, train)
      
      index <- 1
      
      if (!is.null(MCMC_parms)){ # arguments of MCMC params have been passed to the function
        
        # override MCMC settings
        chains <- MCMC_parms[['chains']]
        iter <- MCMC_parms[['iter']]
        refresh <- MCMC_parms[['refresh']]  
        adapt_delta <- MCMC_parms[['adapt_delta']]
        QR <- MCMC_parms[['QR']]
        sparse <- MCMC_parms[['sparse']]
        
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda, chains = chains, iter = iter, refresh = refresh, adapt_delta = adapt_delta, QR = QR, sparse = sparse)
        
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        # calculate MSE for train data
        MSE_train <- train_resid^2 / length(train_resid)
        MSE_array[l,k,1] <- MSE_train
        
        valid_fitted <- posterior_predict(fit, newdata = valid_df) # we use posterior predict when we apply a Bayesian Regression
        valid_resid <- valid_fitted - valid_df[[response]]
        # calculate MSE for validation data
        MSE_valid <- valid_resid^2 / length(valid_resid)
        MSE_array[l,k,2] <- MSE_valid
        
      }
      else{ # MCMC by default (refresh = 0)
        
        fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda)
        
        train_fitted <- fitted(fit)
        train_resid <- resid(fit)
        # calculate MSE for train data
        MSE_train <- train_resid^2 / length(train_resid)
        MSE_array[l,k,1] <- MSE_train
        
        valid_fitted <- posterior_predict(fit, newdata = valid_df) # we use posterior predict when we apply a Bayesian Regression
        valid_resid <- valid_fitted - valid_df[[response]]
        # calculate MSE for validation data
        MSE_valid <- valid_resid^2 / length(valid_resid)
        MSE_array[l,k,2] <- MSE_valid
      }

    }
    
  }
  
  return(MSE_array)
}
# 
# 
# 
# 
# 
# randomizedSearchCV <- function(data, formula, k_fold, stratified_target = NULL, MCMC_parms = NULL, location = 0, lambda_dist, ...){
#   # Randomized Search K-Fold Validation
#   # =====
#   # MCMC_parms: list for controlling MCMC sampling method(chains, iter, refresh)
#   # location: mean of the laplace prior
#   # lambda_dist: distribution function that lambda is going to sample from
#   # ... : named parameters of the lambda_dist:
#   # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
#   # =====
#   # Return: <list> CV_summary 
#   # CV_summary:
#   ##  k-fold:
#   ###   index: k, fit, lambda, train_fitted, train_resid, valid_fitted, valid_resid
#   
#   folds <- k_fold_CV(data = data, stratified_target = stratified_target, k = k_fold, random_k_fold = F)
#   
#   CV_summary <- list()
#   
#   # sample the parameter
#   params_value_vec <- do.call(lambda_dist, list(...))
#   
#   # Randomized Search K-Fold Cross Validation
#   for(k in 1:k_fold){ # run folds datasets
#     
#     valid_df <- folds[[k]]
#     train_df <- do.call(rbind, folds[-k])
#     
#     k_summary <- list()
#     index <- 1
#     response <- strsplit(as.character(formula), "~")[[2]]
# 
#     for (lambda in params_value_vec){ # evaluate each lambda
#       if (!is.null(MCMC_parms)){
#         chains <- MCMC_parms[['chains']]
#         iter <- MCMC_parms[['iter']]
#         refresh <- MCMC_parms[['refresh']]  
#         fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda, chains = chains, iter = iter, refresh = refresh)
#         train_fitted <- fitted(fit)
#         train_resid <- resid(fit)
#         valid_fitted <- posterior_predict(fit, newdata = valid_df)
#         valid_resid <- valid_df[[response]] - valid_fitted
#       }
#       else{
#         fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda)
#         train_fitted <- fitted(fit)
#         train_resid <- resid(fit)
#         valid_fitted <- posterior_predict(fit, newdata = valid_df)
#         valid_resid <- valid_df[[response]] - valid_fitted        
#       }
#       
#       model_summary <- list(k_fold = k, fit = fit, lambda = lambda, 
#                             train_fitted = train_fitted, train_resid = train_resid,
#                             valid_fitted = valid_fitted, valid_residual = valid_resid)
#       
#       k_summary[[index]] <- model_summary
#       index <- index + 1
#     }
#     
#     CV_summary[[paste0('fold',k)]] <- k_summary
#   }
#   
#   return(CV_summary)
# }
# 
# # createGrid <- function(inputList){
# #   # createGrid
# #   # =====
# #   # list: list with params vector that would like to be create into hyperparameter grid for CV
# #   # =====
# #   return(do.call(expand.grid, inputList))
# # }
# 
# gridSearchCV <- function(data, formula, k_fold, stratified_target = NULL, MCMC_parms = NULL, params_vec){
#   # Grid Search K-Fold Validation
#   # =====
#   # MCMC_parms: list for controlling MCMC sampling method(chains, iter, refresh)
#   # params_vec: a vector(1 dim) to pass the desire value of lambdas
#   # =====
#   # Return: <list> CV_summary 
#   # CV_summary:
#   ##  k-fold:
#   ###   index: k, fit, lambda, train_fitted, train_resid, valid_fitted, valid_resid
#   
#   folds <- k_fold_CV(data = data, stratified_target = stratified_target, k = k_fold, random_k_fold = F)
#   
#   CV_summary <- list()
#   
#   # sample the parameter
#   params_value_mat <- createGrid(params_list)
#   
#   # Randomized Search K-Fold Cross Validation
#   for(k in 1:k_fold){ # run folds datasets
#     
#     valid_df <- folds[[k]]
#     train_df <- do.call(rbind, folds[-k])
#     
#     k_summary <- list()
#     index <- 1
#     response <- strsplit(as.character(formula), "~")[[2]]
#     
#     for (lambda in params_vec){ # evaluate each lambda
#       if (!is.null(MCMC_parms)){
#         chains <- MCMC_parms[['chains']]
#         iter <- MCMC_parms[['iter']]
#         refresh <- MCMC_parms[['refresh']]  
#         fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda, chains = chains, iter = iter, refresh = refresh)
#         train_fitted <- fitted(fit)
#         train_resid <- resid(fit)
#         valid_fitted <- posterior_predict(fit, newdata = valid_df)
#         valid_resid <- valid_df[[response]] - valid_fitted
#       }
#       else{
#         fit <- rstan_mixEff_lasso(data = train_df, formula = formula, lambda = lambda)
#         train_fitted <- fitted(fit)
#         train_resid <- resid(fit)
#         valid_fitted <- posterior_predict(fit, newdata = valid_df)
#         valid_resid <- valid_df[[response]] - valid_fitted        
#       }
#       
#       model_summary <- list(k_fold = k, fit = fit, lambda = lambda, 
#                             train_fitted = train_fitted, train_resid = train_resid,
#                             valid_fitted = valid_fitted, valid_residual = valid_resid)
#       
#       k_summary[[index]] <- model_summary
#       index <- index + 1
#     }
#     
#     CV_summary[[paste0('fold',k)]] <- k_summary
#   }
#   
#   return(CV_summary)
# }
# 





































