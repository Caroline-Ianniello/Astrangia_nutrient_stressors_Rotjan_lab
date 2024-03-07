library(rstanarm)
library(tidyverse)
# setwd("/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals")
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

# Documentation -----------------------------------------------------------

#set.MC.cores
  # Specify number of cores for MCMC 
  # ===
  # cores: <int> numbers of cores, if set to -1 then take all resources
  ## Don't set to -1 if you are working on cloud computing clusters.
  # ===
  # return: void

# rstan_mixEff_lasso
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

# customizedRandomizedSearchCV  
  # Randomized Search K-Fold Validation Applying Customized K-Fold CV
  # ===
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MMCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh, adapt_delta, QR, sparse)
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
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh, adapt_delta, QR, sparse)
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

resp_model <- read_csv('MSSP/data/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)

nitrate <- resp_model[resp_model$pollution == 'Nitrate',]
ammonium <- resp_model[resp_model$pollution == 'Ammonium',]


# MCMC cores --------------------------------------------------------------

set.MC.cores(4)

# Customized CV -----------------------------------------------------------

#nitrate
nitrate_resp_MSE_arr <- customizedRandomizedSearchCV(data = nitrate, 
                                                     formula = as.formula('abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num)'),
                                                     fold_number = 5, stratified_target = 'col_num',
                                                     MCMC_parms = list(chains = 4, iter = 2000, refresh = 1, adapt_delta = 0.8, QR = TRUE, sparse = FALSE),
                                                     randomseed = 2023, lambda_dist = rexp, n = 5, rate = 0.8)

save(nitrate_resp_MSE_arr, file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_resp_MSE_arr.RDS')

# ammonium
ammonium_resp_MSE_arr <- customizedRandomizedSearchCV(data = ammonium, 
                                                     formula = as.formula('abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num)'),
                                                     fold_number = 5, stratified_target = 'col_num',
                                                     MCMC_parms = list(chains = 4, iter = 2000, refresh = 1, adapt_delta = 0.8, QR = TRUE, sparse = FALSE),
                                                     randomseed = 2023, lambda_dist = rexp, n = 5, rate = 0.8)



save(ammonium_resp_MSE_arr, file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_resp_MSE_arr.RDS')

