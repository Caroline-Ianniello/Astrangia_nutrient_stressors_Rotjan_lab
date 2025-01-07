library(tidyverse)
library(data.table)
library(reshape2)
setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/TableProcessing/FactorCombinationCreation.R')
rgb <- fread('MSSP/data/raw/RGB_recomputed_dead_deleted_combined_NO3categorized_6_26_24.csv')

# Columns -----------------------------------------------------------------

# [1] "beetag"             "exprun"             "n_species"          "col_num"            "beetag_exprun"      "treat_ID_full"      "N_species_dose"     "temp"              
# [9] "food"               "sym_state"          "red_day1"           "green_day1"         "blue_day1"          "red_day11"          "green_day11"        "blue_day11"        
# [17] "red_delta"          "red_percent_change"

rgb_s <- rgb[,.(col_num, treat_ID_full = str_replace(treat_ID_full, '30', '29'), red_delta, red_percent_change, NO3_category)]

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

dose <- relevel(factor(rgb_s$NO3_category), ref = 'Low')
temp <- factor(split_extract_ID(rgb_s$treat_ID_full, 3), ordered = T, levels = c('20', '29'))
feed <- ifelse(split_extract_ID(rgb_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(rgb_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

rgb_s[, `:=`(dose_level = dose,
             temp = temp, 
             feed = feed, 
             symbiont = symbiont)]


# Create full name treatment ID
rgb_s[, new_treat_ID_full := str_c(dose_level, temp, feed, symbiont, sep = "_")]

# Remove missing target variable num:0
rgb_s <- rgb_s[!(is.na(red_delta) | is.na(red_percent_change)), ]

write_csv(rgb_s, file = 'MSSP/data/ProcessedData/CleanRGB.csv')

# Create Variables --------------------------------------------------------

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 4)

create_columns(rgb_s, twoComb)
create_columns(rgb_s, threeComb)
create_columns(rgb_s, fourComb)

write_csv(rgb_s, 'MSSP/data/ProcessedData/RGB_all_combinations_columns.csv')
