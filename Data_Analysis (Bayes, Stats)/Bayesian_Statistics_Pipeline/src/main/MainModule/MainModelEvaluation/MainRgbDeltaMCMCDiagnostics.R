source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/RGB-Delta/RGB_delta_lasso.RDS')

# RGB-Delta ---------------------------------------------------------------

# nitrate
rgbDelta_var_name <- names(coef(RGB_delta_lasso$BestRefit)[[1]])

plot_trace(RGB_delta_lasso$BestRefit, params = rgbDelta_var_name[1:16])

plot_dens_overlay(RGB_delta_lasso$BestRefit, params = rgbDelta_var_name[1:16])

plot_acf(RGB_delta_lasso$BestRefit, params = rgbDelta_var_name[1:16])
