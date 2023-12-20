source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')



# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Delta/Nitrate_PAM_delta_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Delta/Ammonium_PAM_delta_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------


# nitratefit --------------------------------------------------------------

nit_pamdelta_fit <- Nitrate_PAM_delta_lasso$BestRefit

pp_check(nit_pamdelta_fit)

evaluate_residuals(nit_pamdelta_fit)
plot_residuals(nit_pamdelta_fit)
standirized_resid(nit_pamdelta_fit)
plot_qq(nit_pamdelta_fit)
plot_binned_residuals(nit_pamdelta_fit)


# Ammonium ----------------------------------------------------------------

ammo_pamdelta_fit <- Ammonium_PAM_delta_lasso$BestRefit

pp_check(ammo_pamdelta_fit)

evaluate_residuals(ammo_pamdelta_fit)
plot_residuals(ammo_pamdelta_fit)
standirized_resid(ammo_pamdelta_fit)
plot_qq(ammo_pamdelta_fit)
plot_binned_residuals(ammo_pamdelta_fit)


