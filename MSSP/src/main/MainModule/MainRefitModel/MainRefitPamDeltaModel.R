
source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')
source('MSSP/src/main/model-evaluation/ModelSelect.r')

# Documentation -----------------------------------------------------------

# rstan_mixEff_lasso
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # adapt_delta: <float> specify the  target average proposal acceptance probability during Stan's adaptation period. (when using HMC)
  # QR: <bool> if TRUE applies a scaled qr decomposition to the design matrix
  # sparse: <bool> A logical scalar (defaulting to FALSE) indicating whether to use a sparse representation of the design (X) matrix. 
  ## It is not possible to specify both QR = TRUE and sparse = TRUE.

# refitRstanLasso 
## (data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0, adapt_delta = NULL, QR = FALSE, sparse = FALSE)


# Load Data and best Lambda -----------------------------------------------

pam_model <- read_csv('MSSP/data/PAM_all_combinations_columns.csv')
pam_model$temp <- factor(pam_model$temp, levels = c(20, 30))
nitrate <- pam_model[pam_model$pollution == 'Nitrate',]
ammonium <- pam_model[pam_model$pollution == 'Ammonium',]

# load MSE_array object 

load('MSSP/data/MSE-Arrays/nitrate_pam_delta_MSE_arr.RDS')
load('MSSP/data/MSE-Arrays/ammonium_pam_delta_MSE_arr.RDS')

# average MSE for each lambda

nitrate_pamdelta_best_lambda <- find_best_tune(nitrate_pam_delta_MSE_arr)
ammonium_pamdelta_best_lambda <- find_best_tune(ammonium_pam_delta_MSE_arr)

print(nitrate_pamdelta_best_lambda) 
print(ammonium_pamdelta_best_lambda) 


# Refit -------------------------------------------------------------------

## Nitrate
Nitrate_PAM_delta_lasso <- refitRstanLasso(data = nitrate,
                                           formula = as.formula(paste0('PAM_delta~',
                                                           paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                           '+(1|col_num_3)')),
                                           best_lambda = nitrate_pamdelta_best_lambda,
                                           iter = 4000)


## Ammonium
Ammonium_PAM_delta_lasso <- refitRstanLasso(data = ammonium,
                                            formula = as.formula(paste0('PAM_delta~',
                                                           paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                           '+(1|col_num_3)')),
                                            best_lambda = ammonium_pamdelta_best_lambda,
                                            iter = 4000)



# export the model --------------------------------------------------------

save(Nitrate_PAM_delta_lasso, file = 'MSSP/data/Refit-Models/PAM-Delta//Nitrate_PAM_delta_lasso.RDS')
save(Ammonium_PAM_delta_lasso, file = 'MSSP/data/Refit-Models/PAM-Delta/Ammonium_PAM_delta_lasso.RDS')
