
# Library -----------------------------------------------------------------

pacman::p_load(tidyverse, data.table)

# Load Data ---------------------------------------------------------------
# setwd('/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals')
setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/TableProcessing/FactorCombinationCreation.R')
PAM <- fread('MSSP/data/raw/PAM_dead_deleted_combined_NO3categorized_6_26_24.csv')


# data understanding ------------------------------------------------------

# Columns we got
# [1] "...1"                    "date_coll"               "date_frag"               "col_num"                 "frag_letter"            
# [6] "col_frag_num"            "tile_num"                "tile_position"           "sym_state"               "exp_num"                
# [11] "exp_subrun"              "stand_beetag"            "peg_beetag"              "exp_1_beetag"            "exp_run_full"           
# [16] "beetag_exprun"           "jar_unique_ID"           "temp"                    "PAM_avg_day1"            "PAM_avg_day11"          
# [21] "PAM_delta"               "pam_percent_change"      "log_PAM_delta"           "treat_ID_full"           "treat_ID_dose_temp_food"
# [26] "NO3_mean_observed"       "NH4_mean_observed"       "N_species"               "N_dose"                  "N_species_dose"         
# [31] "control_or_nutrient"     "temp.1"                  "food"                    "sym_state.1"             "food_sym_state"         
# [36] "NO3_category"      


# treat_ID_full
# A_0_20_F_A

#Pollution_dose_temp_feed_symbiont

# Pollution
## A: Ammonia
## N: Nitrate

# dose (0 low medium high, but not in fact 6 levels of doses)
## 0 
## 1.5
## 10
## 18
## 5
## 7.5

# temp
## 20: 20˙C
## 30: 30˙C

# feed
## F: Fed
## S: Starved

# Symbiont
## S: symbiotic
## A: Aposymbiotic

# And now we extract all the characteristics of the experiment, and now we select the columns we need for further exploration.


# Data Subset -------------------------------------------------------------

# I select the columns that are all related to PAM in current stage.

pam_s <- PAM[,.(col_num, treat_ID_full = str_replace(treat_ID_full, '30', '29'), PAM_delta, pam_percent_change, NO3_category)]

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

dose <- relevel(factor(pam_s$NO3_category), ref = 'Low')
temp <- factor(split_extract_ID(pam_s$treat_ID_full, 3), ordered = T, levels = c('20', '29'))
feed <- ifelse(split_extract_ID(pam_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(pam_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

# lapply(list(pollution,dose, temp, feed, symbiont), function(x) sum(is.na(x))) Check missing

pam_s[, `:=`(dose_level = dose,
             temp = temp, 
             feed = feed, 
             symbiont = symbiont)]


# Create new treatment ID:
pam_s[, new_treat_ID_full := str_c(dose_level, temp, feed, symbiont, sep = "_")]

write_csv(pam_s, 'MSSP/data/ProcessedData/CleanPAM.csv')


# data manipulation -------------------------------------------------------

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 4)

create_columns(pam_s, twoComb)
create_columns(pam_s, threeComb)
create_columns(pam_s, fourComb)


write_csv(pam_s, 'MSSP/data/ProcessedData/PAM_all_combinations_columns.csv')
