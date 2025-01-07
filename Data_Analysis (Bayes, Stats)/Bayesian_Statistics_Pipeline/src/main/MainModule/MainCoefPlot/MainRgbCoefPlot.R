setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/Visualization/Coef-Plot.R')
require(readxl)

# Documentation -----------------------------------------------------------

# plot_mixeff_coef
## (refit_model, title)

# Load Refit Models -------------------------------------------------------

# rgb percent change
load('MSSP/data/Refit-Models/RGB-Percent-Change/RGB_percChange_lasso.RDS')

# rgb delta
load('MSSP/data/Refit-Models/RGB-Delta/RGB_delta_lasso.RDS')


# Plot --------------------------------------------------------------------

png('MSSP/doc/Analysis-Log/images/Coef-Plots/RGB-Coef-Plots//Red-Percent-Change-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(RGB_percChange_lasso$BestRefit, title = 'Red Percent Change')
dev.off()

png('MSSP/doc/Analysis-Log/images/Coef-Plots/RGB-Coef-Plots/Red-Delta-Coef.png', width = 800, height = 1200)
plot_mixeff_coef(RGB_delta_lasso$BestRefit, title = 'Red Delta')
dev.off()



# Different CI ------------------------------------------------------------
# Red Delta
Red_delta_est <- read_excel("/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", sheet = 'Red_Delta_Est')

Red_delta_est_plot <- plot_coef_table(Red_delta_est, title = 'Red Delta Estimation')
ggsave('MSSP/doc/Analysis-Log/images/Coef-Plots/RGB-Coef-Plots/Red-Delta-90-95-CI-Coef.svg', plot = Red_delta_est_plot, dpi = 320)

# Red Percent Change
Red_percchange_est <- read_excel("/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", sheet = 'Red_Perc_Est')

Red_percchange_est_plot <- plot_coef_table(Red_percchange_est, title = 'Red Percent Change Estimation')
ggsave('MSSP/doc/Analysis-Log/images/Coef-Plots/RGB-Coef-Plots/Red-Percent-Change-90-95-CI-Coef.svg', plot = Red_percchange_est_plot, dpi = 320)