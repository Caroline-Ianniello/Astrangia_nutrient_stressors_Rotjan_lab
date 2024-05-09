source('MSSP/src/main/Visualization/Coef-Plot.R')



# Documentation -----------------------------------------------------------

# plot_mixeff_coef
## (refit_model, title)



# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/PAM-Percent-Change/Nitrate_PAM_percChange_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Percent-Change/Ammonium_PAM_percChange_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Delta/Ammonium_PAM_delta_lasso.RDS')
load('MSSP/data/Refit-Models/PAM-Delta/Nitrate_PAM_delta_lasso.RDS')


# Plot --------------------------------------------------------------------

png('MSSP/doc/Analysis-Log/images/PAM-Coef-Plots/Nitrate-Pam-Percent-Change-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(Nitrate_PAM_percChange_lasso$BestRefit, title = 'Nitrate Pam Percent Change')
dev.off()

png('MSSP/doc/Analysis-Log/images/PAM-Coef-Plots/Ammonium-Pam-Percent-Change-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(Ammonium_PAM_percChange_lasso$BestRefit, title = 'Ammonium Pam Percent Change')
dev.off()

png('MSSP/doc/Analysis-Log/images/PAM-Coef-Plots/Nitrate-Pam-Delta-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(Nitrate_PAM_delta_lasso$BestRefit, title = 'Nitrate Pam Delta')
dev.off()

png('MSSP/doc/Analysis-Log/images/PAM-Coef-Plots/Ammonium-Pam-Delta-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(Ammonium_PAM_delta_lasso$BestRefit, title = 'Ammonium Pam Delta')
dev.off()
