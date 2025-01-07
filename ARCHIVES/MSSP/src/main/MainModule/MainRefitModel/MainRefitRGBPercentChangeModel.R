
source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')
source('MSSP/src/main/model-evaluation/ModelSelect.r')

# Documentation -----------------------------------------------------------

# refitRstanLasso
  # function(data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0)
  # ===
  #
  #
  #
  #
  # ===



# Load Data and best Lambda -----------------------------------------------

rgb_model <- read_csv('MSSP/data/rgb_all_combinations_columns.csv')

nitrate <- rgb_model[rgb_model$pollution == 'Nitrate',]
ammonium <- rgb_model[rgb_model$pollution == 'Ammonium',]

# load MSE_array object ---------------------------------------------------

load('MSSP/data/MSE-Arrays/nitrate_rgb_percchange_MSE_arr.RDS')
load('MSSP/data/MSE-Arrays/ammonium_rgb_percchange_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_rgbperc_best_lambda <- find_best_tune(nitrate_rgb_percchange_MSE_arr)
ammonium_rgbperc_best_lambda <- find_best_tune(ammonium_rgb_percchange_MSE_arr)

print(nitrate_rgbperc_best_lambda) #
print(ammonium_rgbperc_best_lambda) #


# Refit -------------------------------------------------------------------

## Nitrate
Nitrate_rgb_percChange_lasso <- refitRstanLasso(data = nitrate,
                                                formula = as.formula(paste0('red_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                                best_lambda = nitrate_rgbperc_best_lambda,
                                                iter = 4000)


## Ammonium
Ammonium_rgb_percChange_lasso <- refitRstanLasso(data = ammonium,
                                                formula = as.formula(paste0('red_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                                best_lambda = ammonium_rgbperc_best_lambda,
                                                iter = 4000)



# export the model --------------------------------------------------------

save(Nitrate_rgb_percChange_lasso, file = 'MSSP/data/Refit-Models/rgb-Percent-Change/Nitrate_rgb_percChange_lasso.RDS')
save(Ammonium_rgb_percChange_lasso, file = 'MSSP/data/Refit-Models/rgb-Percent-Change/Ammonium_rgb_percChange_lasso.RDS')
