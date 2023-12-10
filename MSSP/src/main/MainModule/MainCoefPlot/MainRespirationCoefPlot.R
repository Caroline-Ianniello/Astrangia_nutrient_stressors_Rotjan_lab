source('MSSP/src/main/Visualization/Coef-Plot.R')


# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Nitrate_Resp_lasso.RDS')
load('MSSP/data/Refit-Models/Respiration/Ammonium_Resp_lasso.RDS')


png('MSSP/doc/Analysis-Log/images/Respiration-Coef-Plots/Nitrate-Respiration-Coef.png', width = 800, height = 1500)
plot_mixeff_coef(Nitrate_Resp_lasso$BestRefit, title = 'Nitrate Pam Percent Change')
dev.off()

png('MSSP/doc/Analysis-Log/images/Respiration-Coef-Plots/Ammonium-Respiration-Coef.png', width = 800, height = 1500)
plot_mixeff_coef(Ammonium_Resp_lasso$BestRefit, title = 'Ammonium Pam Percent Change')
dev.off()
