source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

# Pam percent change
load('MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_lasso.RDS')


# Pam-Percent-Change ------------------------------------------------------


pamPerc_var_name <- names(coef(PAM_percChange_lasso$BestRefit)[[1]])

plot_trace(PAM_percChange_lasso$BestRefit, params = pamPerc_var_name[1:16])

plot_dens_overlay(PAM_percChange_lasso$BestRefit, params = pamPerc_var_name[1:16])

plot_acf(PAM_percChange_lasso$BestRefit, params = pamPerc_var_name[1:16])
