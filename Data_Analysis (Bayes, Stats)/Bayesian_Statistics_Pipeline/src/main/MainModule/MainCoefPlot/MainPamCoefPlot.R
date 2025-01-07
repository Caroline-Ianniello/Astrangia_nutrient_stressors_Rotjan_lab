setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/Visualization/Coef-Plot.R')
require(readxl)

# Load Refit Models -------------------------------------------------------

# pam percent change
load('MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_lasso.RDS')

# pam delta
load('MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')



# Plot --------------------------------------------------------------------

png('MSSP/doc/Analysis-Log/images/Coef-Plots/PAM-Coef-Plots/Pam-Percent-Change-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(PAM_percChange_lasso$BestRefit, title = 'Pam Percent Change')
dev.off()

png('MSSP/doc/Analysis-Log/images/PAM-Coef-Plots/Pam-Delta-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(PAM_delta_lasso$BestRefit, title = 'Pam Delta')
dev.off()

# Different CI ------------------------------------------------------------
# Pam Delta
Pam_delta_est <- read_excel("/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", sheet = 'PAM_Delta_Est')

Pam_delta_est_plot <- plot_coef_table(Pam_delta_est, title = 'PAM Delta Estimation')
ggsave('MSSP/doc/Analysis-Log/images/Coef-Plots/PAM-Coef-Plots/PAM-Delta-90-95-CI-Coef.svg', plot = Pam_delta_est_plot, dpi = 320)

# Pam Percent Change
Pam_perc_change_est <- read_excel("/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", sheet = 'PAM_Perc_Change_Est')

Pam_perc_change_est_plot <- plot_coef_table(Pam_perc_change_est, title = 'PAM Percent Change Estimation')
ggsave('MSSP/doc/Analysis-Log/images/Coef-Plots/PAM-Coef-Plots/PAM-Percent-Change-90-95-CI-Coef.svg', plot = Pam_perc_change_est_plot, dpi = 320)
