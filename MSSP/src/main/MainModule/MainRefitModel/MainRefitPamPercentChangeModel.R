
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

pam_model <- read_csv('MSSP/data/PAM_all_combinations_columns.csv')

nitrate <- pam_model[pam_model$pollution == 'Nitrate',]
ammonium <- pam_model[pam_model$pollution == 'Ammonium',]

# load MSE_array object ---------------------------------------------------

nitrate_pam_percchange_MSE_arr <- load('MSSP/data/MSE-Arrays/nitrate_pam_percchange_MSE_arr.RDS')
ammonium_pam_percchange_MSE_arr <- load('MSSP/data/MSE-Arrays/ammonium_pam_percchange_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_pamperc_best_lambda <- find_best_tune(nitrate_pam_percchange_MSE_arr)
ammonium_pamperc_best_lambda <- find_best_tune(ammonium_pam_percchange_MSE_arr)

print(nitrate_pamperc_best_lambda) #
print(ammonium_pamperc_best_lambda) #


# Refit -------------------------------------------------------------------

## Nitrate
Nitrate_PAM_percChange_lasso <- refitRstanLasso(data = nitrate,
                                                formula = as.formula(paste0('pam_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                                best_lambda = nitrate_pamperc_best_lambda)


## Ammonium
Ammonium_PAM_percChange_lasso <- refitRstanLasso(data = ammonium,
                                                formula = as.formula(paste0('pam_percent_change~',
                                                               paste(c(c('feed', 'dose_level', 'temp', 'symbiont'),colnames(nitrate)[18:ncol(nitrate)]), collapse = '+'), 
                                                               '+(1|col_num_3)')),
                                                best_lambda = ammonium_pamperc_best_lambda)



# export the model --------------------------------------------------------

save(Nitrate_PAM_percChange_lasso, file = 'MSSP/data/Refit-Models/PAM-Percent-Change/Nitrate_PAM_percChange_lasso.RDS')
save(Ammonium_PAM_percChange_lasso, file = 'MSSP/data/Refit-Models/PAM-Percent-Change/Ammonium_PAM_percChange_lasso.RDS')
