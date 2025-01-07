
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

rgb_model <- read_csv('MSSP/data/rgb_all_combinations_columns.csv')
rgb_model$temp <- factor(rgb_model$temp, levels = c(20, 30))
nitrate <- rgb_model[rgb_model$pollution == 'Nitrate',]
ammonium <- rgb_model[rgb_model$pollution == 'Ammonium',]

# load MSE_array object 

load('MSSP/data/MSE-Arrays/nitrate_rgb_delta_MSE_arr.RDS')
load('MSSP/data/MSE-Arrays/ammonium_rgb_delta_MSE_arr.RDS')

# average MSE for each lambda

nitrate_rgbdelta_best_lambda <- find_best_tune(nitrate_rgb_delta_MSE_arr)
ammonium_rgbdelta_best_lambda <- find_best_tune(ammonium_rgb_delta_MSE_arr)

print(nitrate_rgbdelta_best_lambda) 
print(ammonium_rgbdelta_best_lambda) 


# Refit -------------------------------------------------------------------

## Nitrate
Nitrate_rgb_delta_lasso <- refitRstanLasso(data = nitrate,
                                           formula = as.formula(paste0('red_delta~',
                                                           paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                           '+(1|col_num_3)')),
                                           best_lambda = nitrate_rgbdelta_best_lambda,
                                           iter = 4000)


## Ammonium
Ammonium_rgb_delta_lasso <- refitRstanLasso(data = ammonium,
                                            formula = as.formula(paste0('red_delta~',
                                                           paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                           '+(1|col_num_3)')),
                                            best_lambda = ammonium_rgbdelta_best_lambda,
                                            iter = 4000)



# export the model --------------------------------------------------------

save(Nitrate_rgb_delta_lasso, file = 'MSSP/data/Refit-Models/rgb-Delta//Nitrate_rgb_delta_lasso.RDS')
save(Ammonium_rgb_delta_lasso, file = 'MSSP/data/Refit-Models/rgb-Delta/Ammonium_rgb_delta_lasso.RDS')
