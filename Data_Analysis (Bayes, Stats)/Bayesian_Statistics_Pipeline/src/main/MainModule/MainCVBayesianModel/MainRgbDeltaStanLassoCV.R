library(rstanarm)
library(tidyverse)
# setwd("/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals")
setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
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
# location: <float> Prior location. In most cases, this is the prior mean. Default is 0.
# chain: How many chains for the stan program to conduct the HMC sampler (4 by default)
# iter: number of iteration in each chain. Default is 2000.
# refresh: set to 0 to cancel the output in console. Default is 0.
# adapt_delta: <float> specify the  target average proposal acceptance probability during Stan's adaptation period. (when using HMC)
# QR: <bool> if TRUE applies a scaled qr decomposition to the design matrix
# sparse: <bool> A logical scalar (defaulting to FALSE) indicating whether to use a sparse representation of the design (X) matrix.
# autoscale: <bool> A logical scalar (defaulting to TRUE) indicating whether the scale of the Laplace should be auto adjusted.
## It is not possible to specify both QR = TRUE and sparse = TRUE.
# ===

# customizedRandomizedSearchCV  
# Randomized Search K-Fold Validation Applying Customized K-Fold CV
# ===
# data : <class = data.frame> data to fit model
# formula: <object = formula> formula object to pass to the fit model function
# stratified_target: <string> column name that is the stratified target for k-fold cv.
# MMCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh, adapt_delta, QR, sparse)
# autoscale: <bool> A logical scalar (defaulting to FALSE) indicating whether the scale of the Laplace should be auto adjusted.
# lambda_dist: <callable distribution function> distribution function that lambda is going to sample from
# ... : named parameters of the lambda_dist:
# # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
# ===
# Return: <list> MSE_array
# illustration of matrix for first two dimensions
# ===
#          | fold1 | fold2 | fold3 | fold4 | fold5
# ------------------------------------------------
# lambda_1  |       |       |       |       |
# lambda_2  |       |       |       |       |
# lambda_3  |       |       |       |       |
# lambda_4  |       |       |       |       |
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

rgb_model <- read_csv('MSSP/data/ProcessedData/RGB_all_combinations_columns.csv')

rgb_model$temp <- as.character(rgb_model$temp) # make it into a categorical variable
rgb_model$dose_level <- relevel(factor(rgb_model$dose_level), ref = 'Low') # make sure using Low as reference

# Customized CV -----------------------------------------------------------

set.MC.cores(cores = 4)
rgb_delta_MSE_arr <- customizedRandomizedSearchCV(data = rgb_model, 
                                                  formula = as.formula('red_delta ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num)'),
                                                  fold_number = 5, stratified_target = 'col_num',
                                                  MCMC_parms = list(chains = 4, iter = 2000, refresh = 1, adapt_delta = 0.8, QR = TRUE, sparse = FALSE),
                                                  autoscale = TRUE, randomseed = 2023,
                                                  lambda_dist = rexp, n = 5, rate = 0.8)


## Store results

save(rgb_delta_MSE_arr, file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/rgb_delta_MSE_arr.RDS')
