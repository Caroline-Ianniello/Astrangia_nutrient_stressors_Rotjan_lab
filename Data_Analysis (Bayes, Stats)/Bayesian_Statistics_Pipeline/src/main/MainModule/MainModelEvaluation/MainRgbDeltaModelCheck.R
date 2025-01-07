library(tidyverse)
library(lme4)

# load data ---------------------------------------------------------------

rgb_model <- read_csv('MSSP/data/ProcessedData/RGB_all_combinations_columns.csv')
rgb_model$temp <- factor(rgb_model$temp, levels = c(20, 30))
rgb_model$dose_level <- relevel(factor(rgb_model$dose_level), ref = 'Low')

# Frequentist Fit ---------------------------------------------------------------------

RgbDelta_freqFit <- lmer(formula = red_delta ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num), 
                         data = rgb_model)


# Load Bayesian Models ----------------------------------------------------

load('MSSP/data/Refit-Models/RGB-Delta/RGB_delta_lasso.RDS')

png('MSSP/doc/Analysis-Log/images/Model-Check/Rgb-Delta.png')
plot(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_freqFit),
     xlab = 'Bayesian estimate',
     ylab = 'lme4',
     main = 'Rgb Delta Model Check',
     xlim = range(c(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
dev.off()


# Gaussian prior ----------------------------------------------------------

library(rstanarm)
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

set.MC.cores(cores = 4)

RgbDelta_GassPrior <- stan_glmer(formula = red_delta ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num), 
                            data = rgb_model, 
                            family = gaussian())

# Gaussian prior vs frequentist
plot(fixef(RgbDelta_GassPrior), fixef(RgbDelta_freqFit),
     xlab = 'Bayesian estimate - Gaussian Prior',
     ylab = 'lme4',
     main = 'Rgb Delta Model Check',
     xlim = range(c(fixef(RgbDelta_GassPrior), fixef(RgbDelta_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(RgbDelta_GassPrior), fixef(RgbDelta_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')


# Gaussian prior vs Laplace Prior
plot(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_GassPrior),
     xlab = 'Laplace Prior',
     ylab = 'Gaussian Prior',
     main = 'Rgb Delta Model Check',
     xlim = range(c(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_GassPrior)), na.rm = TRUE),
     ylim = range(c(fixef(RGB_delta_lasso$BestRefit), fixef(RgbDelta_GassPrior)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
