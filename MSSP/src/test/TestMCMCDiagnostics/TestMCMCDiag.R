source('MSSP/src/main/model-evaluation/MCMC-Diagnostics.R')

plot_trace(refit_iris$BestRefit, params = '(Intercept)')

mcmc_trace(as.array(refit_iris$BestRefit)) +
  facet_wrap(vars(chain)) +
  scale_color_discrete()

plot_dens_overlay()