source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')

# Documentation -----------------------------------------------------------

# calculate_SSE()
# evaluate_residuals()
# plot_residuals()
# standirized_resid()
# plot_qq()
# plot_binned_residuals()

# load model object -------------------------------------------------------

load('MSSP/data/Refit-Models/RGB-Delta/RGB_delta_lasso.RDS')


# Residual Diagnostics ----------------------------------------------------


# >>> Bayesian <<< --------------------------------------------------------


# nitratefit Bayesian --------------------------------------------------------------

rgbdelta_fit <- RGB_delta_lasso$BestRefit

pp_check(rgbdelta_fit)

evaluate_residuals(rgbdelta_fit)
plot_residuals(rgbdelta_fit)
standirized_resid(rgbdelta_fit)
plot_qq(rgbdelta_fit)
plot_binned_residuals(rgbdelta_fit)
