source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Ammonium_Resp_lasso.RDS')
load('MSSP/data/Refit-Models/Respiration/Nitrate_Resp_lasso.RDS')

# Respiration ---------------------------------------------------------------

# nitrate

nit_resp_fit <- Nitrate_Resp_lasso$BestRefit

nit_resp_var_name <- names(coef(nit_resp_fit)[[1]])

plot_trace(nit_resp_fit, params = nit_resp_var_name[1:9])

plot_dens_overlay(nit_resp_fit, params = nit_resp_var_name[1:9])

plot_acf(nit_resp_fit, lags = 150, params = nit_resp_var_name[8])

# ammonium

ammo_resp_fit <- Ammonium_Resp_lasso$BestRefit

amm_resp_var_name <- names(coef(ammo_resp_fit)[[1]])

plot_trace(ammo_resp_fit, params = amm_resp_var_name[1:32])

plot_dens_overlay(ammo_resp_fit, params = amm_resp_var_name[1:32])

plot_acf(ammo_resp_fit, lags = 150, params = amm_resp_var_name[21:30])

