library(rstanarm)
library(tidyverse)
# setwd("/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals")
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

# Documentation -----------------------------------------------------------


# rstan_mixEff_lasso
  # Mixed Effect Lasso Bayesian Regression
  # ===
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # ===

# customizedRandomizedSearchCV  
  # Randomized Search K-Fold Validation Applying Customized K-Fold CV
  # ===
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh)
  # location: <int/float> mean of the laplace prior
  # lambda_dist: <callable distribution function> distribution function that lambda is going to sample from
  # ... : named parameters of the lambda_dist:
  # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
  # ===
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # ===
  #          | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lamba_1  |       |       |       |       |
  # lamba_2  |       |       |       |       |
  # lamba_3  |       |       |       |       |
  # lamba_4  |       |       |       |       |
  # ...      |       |       |       |       |
  # lambda_p |       |       |       |       |

#customizedGridSearchCV
  # Grid Search K-Fold Validation Applying Customized K-Fold CV
  # ===
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # fold_number: <int> number k for k-fold CV.
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh)
  # params_vec: Since we are only tuning the parameter "lambda" of laplace distribution, simplifying the program by giving a vector.
  # ===
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # ===
  #           | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lambda_1  |       |       |       |       |
  # lambda_2  |       |       |       |       |
  # lambda_3  |       |       |       |       |
  # lambda_4  |       |       |       |       |
  # ...       |       |       |       |       |
  # lambda_p  |       |       |       |       |


# load data ---------------------------------------------------------------

pam_model <- read_csv('MSSP/data/PAM_all_combinations_columns.csv')

nitrate <- pam_model[pam_model$pollution == 'Nitrate',]
ammonium <- pam_model[pam_model$pollution == 'Ammonium',]

# Customized CV -----------------------------------------------------------

nitrate_pam_percchange_MSE_arr <- customizedRandomizedSearchCV(data = nitrate, 
                                  formula = as.formula(paste0('pam_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                  fold_number = 5, stratified_target = 'col_num_3',
                                  MCMC_parms = list(chains = 4, iter = 2000, refresh = 0),
                                  randomseed = 2023,
                                  lambda_dist = rexp, n = 5, rate = 0.8)

# integrate from 0 to 1 for lambda ~ Exp(0.8) ≈ 0.55
# hist(rexp(1000, 0.8))

ammonium_pam_percchange_MSE_arr <- customizedRandomizedSearchCV(data = ammonium, 
                                  formula = as.formula(paste0('pam_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                  fold_number = 5, stratified_target = 'col_num_3',
                                  MCMC_parms = list(chains = 4, iter = 2000, refresh = 0),
                                  randomseed = 2023,
                                  lambda_dist = rexp, n = 5, rate = 0.8)


## Store results

save(nitrate_pam_percchange_MSE_arr, file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_pam_percchange_MSE_arr.RDS')
save(ammonium_pam_percchange_MSE_arr, file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_pam_percchange_MSE_arr.RDS')














# old version ----------------------------------------------------------------
# 
# 
# nitrate_percent_change_fit <- randomizedSearchCV(data = nitrate, 
#                                   formula = as.formula(paste0('pam_percent_change~',
#                                                                paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
#                                                                '+(1|col_num_3)')),
#                                   k_fold = 5, 
#                                   MCMC_parms = list(chains = 4, iter = 2000, refresh = 0),
#                                   location = 0, 
#                                   lambda_dist = runif,
#                                   n = 5, min = 0, max = 5)
# 
# # change the direction to a folder outside the local git folder, fit file is too large to commit and push to the remote
# # save('nitrate_percent_change_fit', file = 'MSSP/data/model/nitrate_percent_change_fit.RDS')
# 
# ammonium_percent_change_fit <- randomizedSearchCV(data = nitrate, 
#                                    formula = as.formula(paste0('pam_percent_change~',
#                                                                paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
#                                                                '+(1|col_num_3)')),
#                                    k_fold = 5, 
#                                    MCMC_parms = list(chains = 4, iter = 2000, refresh = 0),
#                                    location = 0, 
#                                    lambda_dist = runif,
#                                    n = 5, min = 0, max = 5)
# 
# 
# # change the direction to a folder outside the local git folder, fit file is too large to commit and push to the remote
# # save('ammonium_percent_change_fit', file = 'MSSP/data/model/ammonium_percent_change_fit.RDS')
# 
