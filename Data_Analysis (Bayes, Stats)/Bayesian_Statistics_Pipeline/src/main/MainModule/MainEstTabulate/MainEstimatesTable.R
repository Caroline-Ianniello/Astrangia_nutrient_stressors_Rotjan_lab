source('/projectnb/rotjanlab/git-repo-denny/MSSP/src/main/TableProcessing/CoefEstTable.R')
library(readr)
library(openxlsx)

# PAM Delta ---------------------------------------------------------------

load('/projectnb/rotjanlab/git-repo-denny/MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')
pam_delta_est_table <- tabulate_mixeff_coef(refit_model = PAM_delta_lasso$BestRefit)

# PAM Percent Change ------------------------------------------------------

load('/projectnb/rotjanlab/git-repo-denny/MSSP/data/Refit-Models/PAM-Percent-Change/PAM_percChange_lasso.RDS')
pam_perc_change_est_table <- tabulate_mixeff_coef(refit_model = PAM_percChange_lasso$BestRefit) 

# Respiration -------------------------------------------------------------

load('/projectnb/rotjanlab/git-repo-denny/MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')
resp_est_table <- tabulate_mixeff_coef(refit_model = Resp_lasso$BestRefit) 

# Red Delta ---------------------------------------------------------------

load('/projectnb/rotjanlab/git-repo-denny/MSSP/data/Refit-Models/RGB-Delta/RGB_delta_lasso.RDS')
red_delta_est_table <- tabulate_mixeff_coef(refit_model = RGB_delta_lasso$BestRefit) 

# Red Percent Change ------------------------------------------------------

load('/projectnb/rotjanlab/git-repo-denny/MSSP/data/Refit-Models/RGB-Percent-Change/RGB_percChange_lasso.RDS')
red_perc_est_table <- tabulate_mixeff_coef(refit_model = RGB_percChange_lasso$BestRefit) 


# Export Table ------------------------------------------------------------

write_csv(x = pam_delta_est_table, file = '/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/pam_delta_est_table.csv')
write_csv(x = pam_perc_change_est_table, file = '/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/pam_perc_change_est_table.csv')
write_csv(x = resp_est_table, file = '/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/resp_est_table.csv')
write_csv(x = red_delta_est_table, file = '/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/red_delta_est_table.csv')
write_csv(x = red_perc_est_table, file = '/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/red_perc_est_table.csv')


# Export Excel File -------------------------------------------------------

wb <- createWorkbook()

# Add worksheets and write data
addWorksheet(wb, "PAM_Delta_Est")
writeData(wb, "PAM_Delta_Est", pam_delta_est_table)

addWorksheet(wb, "PAM_Perc_Change_Est")
writeData(wb, "PAM_Perc_Change_Est", pam_perc_change_est_table)

addWorksheet(wb, "Resp_Est")
writeData(wb, "Resp_Est", resp_est_table)

addWorksheet(wb, "Red_Delta_Est")
writeData(wb, "Red_Delta_Est", red_delta_est_table)

addWorksheet(wb, "Red_Perc_Est")
writeData(wb, "Red_Perc_Est", red_perc_est_table)

# Save the workbook to a file
saveWorkbook(wb, file = "/projectnb/rotjanlab/git-repo-denny/MSSP/data/Estimation-Results/All_Estimation_Results.xlsx", overwrite = TRUE)
