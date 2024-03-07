source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')



# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Ammonium_Resp_lasso.RDS')
load('MSSP/data/Refit-Models/Respiration/Nitrate_Resp_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------


# nitratefit --------------------------------------------------------------

nit_resp_fit <- Nitrate_Resp_lasso$BestRefit

pp_check(nit_resp_fit)

evaluate_residuals(nit_resp_fit)
plot_residuals(nit_resp_fit)
standirized_resid(nit_resp_fit)
plot_qq(nit_resp_fit)
plot_binned_residuals(nit_resp_fit)


# Ammonium ----------------------------------------------------------------

ammo_resp_fit <- Ammonium_Resp_lasso$BestRefit

pp_check(ammo_resp_fit)

evaluate_residuals(ammo_resp_fit)
plot_residuals(ammo_resp_fit)
standirized_resid(ammo_resp_fit)
plot_qq(ammo_resp_fit)
plot_binned_residuals(ammo_resp_fit)


