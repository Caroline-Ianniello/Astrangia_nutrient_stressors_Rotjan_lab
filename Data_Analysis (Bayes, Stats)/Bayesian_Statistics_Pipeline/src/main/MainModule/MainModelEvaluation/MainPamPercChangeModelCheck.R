library(tidyverse)
library(lme4)

# load data ---------------------------------------------------------------

pam_model <- read_csv('MSSP/data/ProcessedData/PAM_all_combinations_columns.csv')
pam_model$temp <- factor(pam_model$temp, levels = c(20, 30))
pam_model$dose_level <- relevel(factor(pam_model$dose_level), ref = 'Low')

# Frequentist Fit ---------------------------------------------------------------------

PamPerc_freqFit <- lmer(formula = pam_percent_change ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num), 
                        data = pam_model)


# Load Bayesian Models ----------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_lasso.RDS')

png('MSSP/doc/Analysis-Log/images/Model-Check/Pam-Percent-Change.png')
plot(fixef(PAM_percChange_lasso$BestRefit), fixef(PamPerc_freqFit),
     xlab = 'Bayesian estimate',
     ylab = 'lme4',
     main = 'Pam Percentage Change Model Check',
     xlim = range(c(fixef(PAM_percChange_lasso$BestRefit), fixef(PamPerc_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(PAM_percChange_lasso$BestRefit), fixef(PamPerc_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
dev.off()

# Gaussian prior ----------------------------------------------------------

library(rstanarm)
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')
set.MC.cores(cores = 4)

PAM_percChange_Gaussian <- stan_glmer(formula = pam_percent_change ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num), 
                            data = pam_model, 
                            family = gaussian(), 
                            prior = default_prior_coef(family = gaussian))

# Gaussian prior vs frequentist
png('MSSP/doc/Analysis-Log/images/Model-Check/Pam-Percent-Change-GaussianPrior.png')
plot(fixef(PAM_percChange_Gaussian), fixef(PamPerc_freqFit),
     xlab = 'Bayesian estimate - Gaussian Prior',
     ylab = 'lme4',
     main = 'Pam Percent Change Model Check',
     xlim = range(c(fixef(PAM_percChange_Gaussian), fixef(PamPerc_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(PAM_percChange_Gaussian), fixef(PamPerc_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
dev.off()

# Gaussian prior vs Laplace Prior
plot(fixef(PAM_percChange_lasso$BestRefit), fixef(PAM_percChange_Gaussian),
     xlab = 'Laplace Prior',
     ylab = 'Gaussian Prior',
     main = 'Pam Percent Change Model Check',
     xlim = range(c(fixef(PAM_percChange_lasso$BestRefit), fixef(PAM_percChange_Gaussian)), na.rm = TRUE),
     ylim = range(c(fixef(PAM_percChange_lasso$BestRefit), fixef(PAM_percChange_Gaussian)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')



# Export Gaussian Prior Model ---------------------------------------------

save(PAM_percChange_Gaussian, file = 'MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_Gaussian.RDS')
