setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/Visualization/Coef-Plot.R')
require(readxl)

# Load Refit Models -------------------------------------------------------

load('MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')

png('MSSP/doc/Analysis-Log/images/Coef-Plots/Respiration-Coef-Plots/Respiration-Coef.png', width = 800, height = 1500)
plot_mixeff_coef(Resp_lasso$BestRefit, title = 'Absolute Respiration Rate Surface Area Adjusted')
dev.off()

# Different CI ------------------------------------------------------------
resp_est <- read_excel("/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", sheet = 'Resp_Est')

resp_est_plot <- plot_coef_table(resp_est, title = 'Respiration Rate Estimation')
ggsave('MSSP/doc/Analysis-Log/images/Coef-Plots/Respiration-Coef-Plots/Respiration-90-95-CI-Coef.svg', plot = resp_est_plot, dpi = 320)

