
##################### TEST #####################

library(rstanarm)
library(tidyverse)

source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

# rstan_mixEff_lasso
  # Mixed Effect Lasso Bayesian Regression
  # ======
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # ======

# randomizedSearchCV
  # Randomized Search K-Fold Validation
  # =====
  # MCMC_parms: list for controlling MCMC sampling method(chains, iter, refresh)
  # location: mean of the laplace prior
  # lambda_dist: distribution function that lambda is going to sample from
  # ... : named parameters of the lambda_dist:
  # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
  # =====

# Grid Search K-Fold Validation
  # =====
  # MCMC_parms: list for controlling MCMC sampling method(chains, iter, refresh)
  # params_vec: a vector(1 dim) to pass the desire value of lambdas
  # =====
  # Return: <list> CV_summary 
  # CV_summary:
  ##  k-fold:
  ###   index: k, fit, lambda, train_fitted, train_resid, valid_fitted, valid_resid

# modeling ----------------------------------------------------------------

pam_model <- read_csv('MSSP/data/PAM_all_combinations_columns.csv')

nitrate <- pam_model[pam_model$pollution == 'Nitrate',]
ammonium <- pam_model[pam_model$pollution == 'Ammonium',]

nitrate_pam_delta_fit <- randomizedSearchCV(
                                  data = nitrate, 
                                  formula = as.formula(paste0('PAM_delta~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)', collapse = '')),
                                  k_fold = 3, 
                                  stratified_target = 'col_num_3',
                                  MCMC_parms = list(chains = 2, iter = 2000, refresh = 0),
                                  location = 0, 
                                  lambda_dist = runif,
                                  n = 1, min = 0, max = 1)


tmp <-as.formula(paste0('PAM_delta~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)', collapse = ''))

strsplit(as.character(tmp), "~")[[2]]



iris_rstan <- randomizedSearchCV(data = iris, 
                                  formula = as.formula(paste0('Sepal.Length~',
                                                               paste(c("Sepal.Width", "Petal.Length", "Petal.Width"), collapse = '+'), 
                                                               '+(1|Species)')),
                                  k_fold = 3, 
                                  stratified_target = 'Species',
                                  MCMC_parms = list(chains = 2, iter = 2000, refresh = 0),
                                  location = 0, 
                                  lambda_dist = runif,
                                  n = 1, min = 0, max = 1)









