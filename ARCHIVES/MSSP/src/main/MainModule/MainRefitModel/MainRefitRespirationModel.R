source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')
source('MSSP/src/main/model-evaluation/ModelSelect.r')

# Documentation -----------------------------------------------------------

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

# refitRstanLasso 
## (data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0, adapt_delta = NULL, QR = FALSE, sparse = FALSE)

# load data ---------------------------------------------------------------

resp_model <- read_csv('MSSP/data/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)

nitrate <- resp_model[resp_model$pollution == 'Nitrate',]
ammonium <- resp_model[resp_model$pollution == 'Ammonium',]

# load MSE_array object 

load('MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_resp_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_resp_MSE_arr.RDS')

# average MSE for each lambda

nitrate_resp_best_lambda <- find_best_tune(nitrate_resp_MSE_arr)
ammonium_resp_best_lambda <- find_best_tune(ammonium_resp_MSE_arr)

print(nitrate_resp_best_lambda) 
print(ammonium_resp_best_lambda) 

# Refit -------------------------------------------------------------------

set.MC.cores(4)

## Nitrate
Nitrate_Resp_lasso <- refitRstanLasso(data = nitrate,
                                           formula = as.formula('abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num)'),
                                           best_lambda = nitrate_resp_best_lambda, chains = 4, refresh = 1, iter = 2000)


## Ammonium
Ammonium_Resp_lasso <- refitRstanLasso(data = ammonium,
                                            formula = as.formula('abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num)'),
                                            best_lambda = ammonium_resp_best_lambda, chains = 4, refresh = 1, iter = 4000)


# export the model --------------------------------------------------------

save(Nitrate_Resp_lasso, file = 'MSSP/data/Refit-Models/Respiration/Nitrate_Resp_lasso.RDS')
save(Ammonium_Resp_lasso, file = 'MSSP/data/Refit-Models/Respiration/Ammonium_Resp_lasso.RDS')


