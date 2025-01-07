source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')


# Documentation -----------------------------------------------------------

# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------

resp_fit <- Resp_lasso$BestRefit

pp_check(resp_fit)
evaluate_residuals(resp_fit)
plot_residuals(resp_fit)
standirized_resid(resp_fit)
plot_qq(resp_fit)
plot_binned_residuals(resp_fit)
