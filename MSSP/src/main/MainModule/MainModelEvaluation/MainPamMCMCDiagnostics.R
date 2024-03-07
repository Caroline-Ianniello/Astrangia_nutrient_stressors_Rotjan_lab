source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Percent-Change/Nitrate_PAM_percChange_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Percent-Change/Ammonium_PAM_percChange_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Delta/Ammonium_PAM_delta_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Delta/Nitrate_PAM_delta_lasso.RDS')

# PAM-Delta ---------------------------------------------------------------

# nitrate
nit_pamDelta_var_name <- names(coef(Nitrate_PAM_delta_lasso$BestRefit)[[1]])

plot_trace(Nitrate_PAM_delta_lasso$BestRefit, params = nit_pamDelta_var_name[1:9])

plot_dens_overlay(Nitrate_PAM_delta_lasso$BestRefit, params = nit_pamDelta_var_name[1:9])

plot_acf(Nitrate_PAM_delta_lasso$BestRefit, params = nit_pamDelta_var_name[1:9])

# ammonium

amm_pamDelta_var_name <- names(coef(Ammonium_PAM_delta_lasso$BestRefit)[[1]])

plot_trace(Ammonium_PAM_delta_lasso$BestRefit, params = amm_pamDelta_var_name[1:32])

plot_dens_overlay(Ammonium_PAM_delta_lasso$BestRefit, params = amm_pamDelta_var_name[1:32])

plot_acf(Ammonium_PAM_delta_lasso$BestRefit, params = amm_pamDelta_var_name[1:32])



# Pam-Percent-Change ------------------------------------------------------


# nitrate

nit_pamPerc_var_name <- names(coef(Nitrate_PAM_percChange_lasso$BestRefit)[[1]])

plot_trace(Nitrate_PAM_percChange_lasso$BestRefit, params = nit_pamPerc_var_name[1:9])

plot_dens_overlay(Nitrate_PAM_percChange_lasso$BestRefit, params = nit_pamPerc_var_name[1:9])

plot_acf(Nitrate_PAM_percChange_lasso$BestRefit, params = nit_pamPerc_var_name[1:9])

# ammonium
amm_pamPerc_var_name <- names(coef(Ammonium_PAM_percChange_lasso$BestRefit)[[1]])

plot_trace(Ammonium_PAM_percChange_lasso$BestRefit, params = amm_pamPerc_var_name[1:32])

plot_dens_overlay(Ammonium_PAM_percChange_lasso$BestRefit, params = amm_pamPerc_var_name[1:32])

plot_acf(Ammonium_PAM_percChange_lasso$BestRefit, params = amm_pamPerc_var_name[1:32])



