library(tidyverse)
library(data.table)
library(reshape2)
setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/TableProcessing/FactorCombinationCreation.R')
resp <- fread('MSSP/data/raw/resp_combined_NO3categorized_outlier_removed_6_24_24.csv')


# Columns -----------------------------------------------------------------


# [1] "V1"                          "X"                           "date"                        "exp_num"                    
# [5] "exp_subrun"                  "resp_run"                    "e_coli_plate"                "vial_ID"                    
# [9] "vial_id_copy_pasted"         "resp_rate"                   "resp_rate_SA_corr"           "abs_resp_rate_SA_corr"      
# [13] "treat_ID_full"               "treat_ID_dose_temp_food"     "NO3_mean_observed"           "NH4_mean_observed"          
# [17] "treat_ID_collapsed_controls" "food_sym_state"              "N_species_dose"              "N_species"                  
# [21] "control_or_nutrient"         "N_dose"                      "temp"                        "food"                       
# [25] "sym_state"                   "beetag"                      "exp_run_full"                "beetag_exprun"              
# [29] "col_num"                     "jar_unique_ID"               "broken_or_damaged"           "NO3_category"      

# Break down treatment ID -------------------------------------------------

resp_s <- resp[,.(col_num, treat_ID_full = str_replace(treat_ID_full, '30', '29'), e_coli = e_coli_plate, abs_resp_rate_SA_corr, NO3_category)]

# We separate the treat_ID_full back to each combination component.

split_extract_ID <- function(vec, n){
  if (n == 1){
    out <- sapply(strsplit(vec, "_"), head, n = 1)
  }
  else if(n == 5){
    out <- sapply(strsplit(vec, "_"), tail, n = 1)
  }
  else{
    out <- sapply(strsplit(vec, "_"), function(x) if(length(x) >= n) x[n] else NA)
  }

  return(out)
}


dose <- relevel(factor(resp_s$NO3_category), ref = 'Low')
temp <- factor(split_extract_ID(resp_s$treat_ID_full, 3), ordered = T, levels = c('20', '29'))
feed <- ifelse(split_extract_ID(resp_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(resp_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

# append treatment factors back to data
resp_s[, `:=`(dose_level = dose,
              temp = temp, 
              feed = feed, 
              symbiont = symbiont)]


# Create full name treatment ID
resp_s[, new_treat_ID_full := str_c(dose_level, temp, feed, symbiont, sep = "_")]

# Remove missing resp_rate num:8
resp_s <- resp_s[!is.na(abs_resp_rate_SA_corr), ]

write_csv(resp_s, file = 'MSSP/data/ProcessedData/CleanRespiration.csv')


# Create Variables --------------------------------------------------------

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 4)
fiveComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 5)

create_columns(resp_s, twoComb)
create_columns(resp_s, threeComb)
create_columns(resp_s, fourComb)
create_columns(resp_s, fiveComb)

write_csv(resp_s, 'MSSP/data/ProcessedData/Respiration_all_combinations_columns.csv')

