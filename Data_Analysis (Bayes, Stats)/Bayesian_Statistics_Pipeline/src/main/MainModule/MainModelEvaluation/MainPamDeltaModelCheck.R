library(tidyverse)
library(lme4)

# load data ---------------------------------------------------------------

pam_model <- read_csv('MSSP/data/ProcessedData/PAM_all_combinations_columns.csv')
pam_model$temp <- factor(pam_model$temp, levels = c(20, 30))
pam_model$dose_level <- relevel(factor(pam_model$dose_level), ref = 'Low')

# Frequentist Fit ---------------------------------------------------------------------

PamDelta_freqFit <- lmer(formula = PAM_delta ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num), 
                         data = pam_model)

# Load Bayesian Models ----------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')

    
png('MSSP/doc/Analysis-Log/images/Model-Check/Pam-Delta.png')
plot(fixef(PAM_delta_lasso$BestRefit), fixef(PamDelta_freqFit),
     xlab = 'Bayesian estimate',
     ylab = 'lme4',
     main = 'Pam Delta Model Check',
     xlim = range(c(fixef(PAM_delta_lasso$BestRefit), fixef(PamDelta_freqFit)), na.rm = TRUE),
     ylim = range(c(fixef(PAM_delta_lasso$BestRefit), fixef(PamDelta_freqFit)), na.rm = TRUE))
abline(a = 0, b = 1, col = 'red')
dev.off()

