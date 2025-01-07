source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

# pam delta
load('MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')


# PAM-Delta ---------------------------------------------------------------


pamDelta_var_name <- names(coef(PAM_delta_lasso$BestRefit)[[1]])

plot_trace(PAM_delta_lasso$BestRefit, params = pamDelta_var_name[1:16])

plot_dens_overlay(PAM_delta_lasso$BestRefit, params = pamDelta_var_name[1:16])

plot_acf(PAM_delta_lasso$BestRefit, params = pamDelta_var_name[1:16])

