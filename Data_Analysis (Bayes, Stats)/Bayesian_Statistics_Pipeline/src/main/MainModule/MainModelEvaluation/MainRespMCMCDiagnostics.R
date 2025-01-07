source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')

# Respiration ---------------------------------------------------------------

resp_fit <- Resp_lasso$BestRefit

resp_var_name <- names(coef(resp_fit)[[1]])

plot_trace(resp_fit, params = resp_var_name[1:9])

plot_dens_overlay(resp_fit, params = resp_var_name[1:9])

plot_acf(resp_fit, lags = 150, params = resp_var_name[1:32])
