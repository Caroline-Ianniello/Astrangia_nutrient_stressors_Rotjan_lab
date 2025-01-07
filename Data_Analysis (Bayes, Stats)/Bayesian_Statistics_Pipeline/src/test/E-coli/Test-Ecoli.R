setwd('/projectnb/rotjanlab/git-repo-denny') # SCC

resp_model <- read_csv('MSSP/data/ProcessedData/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)

nitrate_resp <- resp_model[resp_model$pollution == 'Nitrate',]
ammonium_resp <- resp_model[resp_model$pollution == 'Ammonium',]