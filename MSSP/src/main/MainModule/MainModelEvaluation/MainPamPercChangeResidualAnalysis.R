source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')


# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Percent-Change/Nitrate_PAM_percChange_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Percent-Change/Ammonium_PAM_percChange_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------


# Ammonium ----------------------------------------------------------------

ammo_perc_fit <- Ammonium_PAM_percChange_lasso$BestRefit

pp_check(ammo_perc_fit)

evaluate_residuals(ammo_perc_fit)
plot_residuals(ammo_perc_fit)
standirized_resid(ammo_perc_fit)
plot_qq(ammo_perc_fit)
plot_binned_residuals(ammo_perc_fit)


# Nitrate -----------------------------------------------------------------

nit_perc_fit <- Nitrate_PAM_percChange_lasso$BestRefit

pp_check(nit_perc_fit)

evaluate_residuals(nit_perc_fit)
plot_residuals(nit_perc_fit)
standirized_resid(nit_perc_fit)
plot_qq(nit_perc_fit)
plot_binned_residuals(nit_perc_fit)
