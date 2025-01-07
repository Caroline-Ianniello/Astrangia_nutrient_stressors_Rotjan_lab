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

load('MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_pam_delta_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_pam_delta_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_pam_percchange_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_pam_percchange_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_resp_MSE_arr.RDS')
load('MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_resp_MSE_arr.RDS')


# Nitrate Pam Delta Change ----------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/nitrate-pam-delta-MSE.png')
MSE_violin_plot(nitrate_pam_delta_MSE_arr, which_MSE = 'valid', title = 'Nitrate - PAM_Delta - MSE - Valid ')
dev.off()


# Ammonium Pam Delta Change ---------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/ammonium-pam-delta-MSE.png')
MSE_violin_plot(ammonium_pam_delta_MSE_arr, which_MSE = 'valid', title = 'Ammonium - PAM_Delta - MSE - Valid ')
dev.off()


# Nitrate Pam Percent Change ----------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/nitrate-pam-percent-change-MSE.png')
MSE_violin_plot(nitrate_pam_percchange_MSE_arr, which_MSE = 'valid', title = 'Nitrate - PAM_Percent_Change - MSE - Valid ')
dev.off()

# Ammonium Pam Percent Change ---------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/pam/ammonium-pam-percent-change-MSE.png')
MSE_violin_plot(ammonium_pam_percchange_MSE_arr, which_MSE = 'valid', title = 'Ammonium - PAM_Percent_Change - MSE - Valid ')
dev.off()


# Nitrate Respiration Rate ------------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/respiration/nitrate-respiration-MSE.png')
MSE_violin_plot(nitrate_resp_MSE_arr, which_MSE = 'valid', title = 'Nitrate - Respiration_Rate - MSE - Valid ')
dev.off()

# Ammonium Respiration Rate ------------------------------------------------

png('MSSP/doc/Analysis-Log/images/MSE-Violin-Plots/respiration/ammonium-respiration-MSE.png')
MSE_violin_plot(ammonium_resp_MSE_arr, which_MSE = 'valid', title = 'Ammonium - Respiration_Rate - MSE - Valid ')
dev.off()
