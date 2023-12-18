library(tidyverse)
library(data.table)
library(reshape2)

resp <- fread('MSSP/data/raw/RESP_ALL_SUMMARY_ALL_cleaned_dead_and_broken_outlierG28Y65_deleted_SA_CORR_12_13_2023.csv')


# Columns -----------------------------------------------------------------


# [1] "num"                         "date"                        "exp_num"                     "exp_subrun"                 
# [5] "resp_run"                    "e_coli_plate"                "vial_ID"                     "vial_id_copy_pasted"        
# [9] "resp_rate"                   "treat_ID_full"               "treat_ID_collapsed_controls" "food_sym_state"             
# [13] "N_species_dose"             "N_species"                   "N_dose"                      "temp"                       
# [17] "food"                       "sym_state"                   "beetag"                      "exp_run_full"               
# [21] "beetag_exprun"              "col_num"                     "jar_unique_ID"               "broken_or_damaged" 

# Break down treatment ID -------------------------------------------------

resp_s <- resp[,.(col_num, treat_ID_full, e_coli = e_coli_plate, resp_rate)]

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

pollution <- ifelse(split_extract_ID(resp_s$treat_ID_full, 1) == 'N', 'Nitrate', 'Ammonium')
dose <- factor(split_extract_ID(resp_s$treat_ID_full, 2), ordered = T, levels = c('0', '1.5', '5', '7.5', '10', '18'))
temp <- factor(split_extract_ID(resp_s$treat_ID_full, 3), ordered = T, levels = c('20', '30'))
feed <- ifelse(split_extract_ID(resp_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(resp_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

# append treatment factors back to data
resp_s[, `:=`(pollution = pollution,
             dose = dose,
             temp = temp, 
             feed = feed, 
             symbiont = symbiont)]

# Create dose_level based on pollution type and dose
resp_s[, dose_level := fcase(pollution == 'Nitrate' & dose == '0' , 'control-0',
                            pollution == 'Nitrate' & dose == '1.5' , 'Low',
                            pollution == 'Nitrate' & dose == '5' , 'Medium',
                            pollution == 'Nitrate' & dose == '18' , 'High',
                            pollution == 'Ammonium' & dose == '0' , 'control-0',
                            pollution == 'Ammonium' & dose == '5' , 'Low',
                            pollution == 'Ammonium' & dose == '7.5' , 'Medium',
                            pollution == 'Ammonium' & dose == '10' , 'High',
                            default = NA_character_)]

# Create full name treatment ID
resp_s[, new_treat_ID_full := str_c(pollution, dose_level, temp, feed, symbiont, sep = "_")]

# Remove missing resp_rate num:8
resp_s <- resp_s[!is.na(resp_rate), ]

write_csv(resp_s, file = 'MSSP/data/CleanRespiration.csv')


# Create Variables --------------------------------------------------------

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 4)
fiveComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont', 'e_coli'), 5)

concatenate_columns <- function(df, cols) {
  apply(df[, .SD, .SDcols = cols], 1, paste, collapse = "-x-")
}

create_columns <- function(df, combinations){
  for (i in 1:ncol(combinations)) {
    combo <- combinations[, i]
    new_col_name <- paste(combo, collapse = "_x_")
    
    df[,(new_col_name) := concatenate_columns(df, combo)]
  }
}

create_columns(resp_s, twoComb)
create_columns(resp_s, threeComb)
create_columns(resp_s, fourComb)
create_columns(resp_s, fiveComb)

write_csv(resp_s, 'MSSP/data/Respiration_all_combinations_columns.csv')

