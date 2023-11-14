if(!requireNamespace('bayesplot')){
  download.packages('bayesplot')
}

library(bayesplot)


# Trace Plot --------------------------------------------------------------


plot_trace <- function(model, params, check_separated = T) {
  if (check_separated){
    trace <- mcmc_trace(as.array(model), pars = params) +
      facet_wraps(vars(params)) +
      scale_color_discrete()
  }
  else{
    trace <- mcmc_trace(as.array(model), pars = params)
  }
  print(trace)
}

# Density Overlay Plot ----------------------------------------------------

plot_dens_overlay <- function(model, params) {
  density <- mcmc_dens_overlay(model, pars = params) +
  print(density)
}


# ACF plot ----------------------------------------------------------------

plot_acf <- function(model, lags = 50) {
  autocorr <- mcmc_acf(as.array(model), lags = lags)
  print(autocorr)
}

