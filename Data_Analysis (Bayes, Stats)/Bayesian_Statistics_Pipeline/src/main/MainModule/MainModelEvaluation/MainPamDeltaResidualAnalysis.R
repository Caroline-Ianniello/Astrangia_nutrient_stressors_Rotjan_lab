source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')



# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------


# nitratefit --------------------------------------------------------------

pamdelta_fit <- PAM_delta_lasso$BestRefit

pp_check(pamdelta_fit)

evaluate_residuals(pamdelta_fit)
plot_residuals(pamdelta_fit)
standirized_resid(pamdelta_fit)
plot_qq(pamdelta_fit)
plot_binned_residuals(pamdelta_fit)
