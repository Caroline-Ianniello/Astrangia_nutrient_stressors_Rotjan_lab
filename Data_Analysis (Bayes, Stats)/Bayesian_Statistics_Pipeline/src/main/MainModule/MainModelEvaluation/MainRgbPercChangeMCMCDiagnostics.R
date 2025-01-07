source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')


# Documentation -----------------------------------------------------------

# plot_trace(model, params = NULL, check_separated = T)
# plot_dens_overlay(model, params)
# plot_acf(model, lags = 50)


# Load Refit Models -------------------------------------------------------


load('MSSP/data/Refit-Models/RGB-Percent-Change/RGB_percChange_lasso.RDS')

# Rgb-Percent-Change ------------------------------------------------------


# nitrate

rgbPerc_var_name <- names(coef(RGB_percChange_lasso$BestRefit)[[1]])

plot_trace(RGB_percChange_lasso$BestRefit, params = rgbPerc_var_name[1:9])

plot_dens_overlay(RGB_percChange_lasso$BestRefit, params = rgbPerc_var_name[1:32])

plot_acf(RGB_percChange_lasso$BestRefit, params = rgbPerc_var_name[1:32])

