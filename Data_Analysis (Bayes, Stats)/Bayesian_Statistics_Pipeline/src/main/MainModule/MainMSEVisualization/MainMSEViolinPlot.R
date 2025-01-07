setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/Visualization/MSE_violin_plot.R')


# Documentation -----------------------------------------------------------

# MSE_violin_plot
  # (MSE_array, which_MSE = 'valid', title)
  # Violin Plot for MSE array
  # ===
  # which_MSE: <string> 'both' / 'train' / 'valid'
  # title: <string> plot title
  # ===
  # Return: void


# Load MSE Arrays ---------------------------------------------------------

# pam delta
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/pam_delta_MSE_arr.RDS')

# pam percent change
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/pam_percchange_MSE_arr.RDS')

# respiration
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/resp_MSE_arr.RDS')

# rgb delta
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/rgb_delta_MSE_arr.RDS')

# rgb percent change
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/rgb_percchange_MSE_arr.RDS')

# Pam Delta Change ----------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/pam-delta-MSE.png')
MSE_violin_plot(pam_delta_MSE_arr, which_MSE = 'valid', title = 'PAM_Delta - MSE - Valid ')
dev.off()


# Pam Percent Change ----------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/pam-percent-change-MSE.png')
MSE_violin_plot(pam_percchange_MSE_arr, which_MSE = 'valid', title = 'PAM_Percent_Change - MSE - Valid ')
dev.off()


# Respiration Rate ------------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/respiration/respiration-MSE.png')
MSE_violin_plot(resp_MSE_arr, which_MSE = 'valid', title = 'Respiration_Rate - MSE - Valid ')
dev.off()


# RGB Delta -------------------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/rgb/rgb-delta-MSE.png')
MSE_violin_plot(rgb_delta_MSE_arr, which_MSE = 'valid', title = 'Red Delta - MSE - Valid ')
dev.off()


# Nitrate RGB Percent Change -------------------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/rgb/rgb-percent-change-MSE.png')
MSE_violin_plot(rgb_percchange_MSE_arr, which_MSE = 'valid', title = 'Red Percent_Change - MSE - Valid ')
dev.off()

