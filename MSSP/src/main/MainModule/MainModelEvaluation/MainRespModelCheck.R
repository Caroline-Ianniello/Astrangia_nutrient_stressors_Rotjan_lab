
library(lme4)

# load data ---------------------------------------------------------------

resp_model <- read_csv('MSSP/data/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)

nitrate <- resp_model[resp_model$pollution == 'Nitrate',]
ammonium <- resp_model[resp_model$pollution == 'Ammonium',]

# Frequentist Fit ---------------------------------------------------------------------

Nitrate_Resp_freqFit <- lmer(formula = resp_rate ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num), 
                              data = nitrate)

Ammonium_Resp_freqFit <- lmer(formula = resp_rate ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num), 
                              data = ammonium)

# Load Bayesian Models ----------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Nitrate_Resp_lasso.RDS')
load('MSSP/data/Refit-Models/Respiration/Ammonium_Resp_lasso.RDS')

png('MSSP/doc/Analysis-Log/images/Model-Check/Nitrate-Respiration-Rate.png')
plot(fixef(Nitrate_Resp_lasso$BestRefit),fixef(Nitrate_Resp_freqFit), xlab = 'Bayesian estimate', ylab = 'lme4')
abline(a = 0, b = 1, col = 'red')
dev.off()

png('MSSP/doc/Analysis-Log/images/Model-Check/Ammonium-Respiration-Rate.png')
plot(fixef(Ammonium_Resp_lasso$BestRefit),fixef(Ammonium_Resp_freqFit), xlab = 'Bayesian estimate', ylab = 'lme4')
abline(a = 0, b = 1, col = 'red')
dev.off()









