library(tidyverse)
library(lme4)

# load data ---------------------------------------------------------------

resp_model <- read_csv('MSSP/data/ProcessedData/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)
resp_model$dose_level <- relevel(factor(resp_model$dose_level), ref = 'Low')

# Frequentist Fit ---------------------------------------------------------------------

Resp_freqFit <- lmer(formula = abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num), 
                     data = resp_model)
# Load Bayesian Models ----------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')

png('MSSP/doc/Analysis-Log/images/Model-Check/Respiration-Rate.png')
plot(fixef(Resp_lasso$BestRefit), fixef(Resp_freqFit),
     xlab = 'Bayesian estimate',
     ylab = 'lme4',
     main = 'Respiration Model Check',
     xlim = range(c(fixef(Resp_lasso$BestRefit), fixef(Resp_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(Resp_lasso$BestRefit), fixef(Resp_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
dev.off()

# Gaussian prior ----------------------------------------------------------

library(rstanarm)
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')
set.MC.cores(cores = 4)

Resp_GassPrior <- stan_glmer(formula = abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num), 
                             data = resp_model, 
                             family = gaussian())

# Gaussian prior vs frequentist
plot(fixef(Resp_GassPrior), fixef(Resp_freqFit),
     xlab = 'Bayesian estimate - Gaussian Prior',
     ylab = 'lme4',
     main = 'Respiration Model Check',
     xlim = range(c(fixef(Resp_GassPrior), fixef(Resp_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(Resp_GassPrior), fixef(Resp_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')


# Gaussian prior vs Laplace Prior
plot(fixef(Resp_lasso$BestRefit), fixef(Resp_GassPrior),
     xlab = 'Laplace Prior',
     ylab = 'Gaussian Prior',
     main = 'Respiration Model Check',
     xlim = range(c(fixef(Resp_lasso$BestRefit), fixef(Resp_GassPrior)), na.rm = TRUE),
     ylim = range(c(fixef(Resp_lasso$BestRefit), fixef(Resp_GassPrior)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')