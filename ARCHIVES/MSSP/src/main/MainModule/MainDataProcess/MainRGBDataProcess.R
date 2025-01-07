
# Library -----------------------------------------------------------------

pacman::p_load(tidyverse, data.table)


# Load Data ---------------------------------------------------------------
setwd("C:/Users/carol/OneDrive/Documents/PhD Boston University 2019-/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/")
rgb <- read_csv('data/raw/RGB_NITRATEandAMMONIUM_Recomputted_12_18_23_dead_deleted_4_29_24.csv')

rgb <- as.data.table(rgb)


# data understanding ------------------------------------------------------

# Columns we got
#  [1] "date_coll"           "date_frag"           "col_num...3"         "frag_letter"         "col_frag_num"        "tile_num"           
#  [7] "tile_position"       "sym_state...8"       "exp_num"             "exp_subrun"          "stand_beetag"        "peg_beetag"         
# [13] "exp_1_beetag"        "exp_run_full"        "beetag_exprun"       "col_num...16"        "jar_unique_ID"       "temp...18"          
# [19] "rgb_avg_day1"        "rgb_avg_day11"       "rgb_delta"           "rgb_percent_change"  "log_rgb_delta"       "treat_ID_full"      
# [25] "N_species"           "N_dose"              "N_species_dose"      "control_or_nutrient" "temp...29"           "food"               
# [31] "sym_state...31"      "food_sym_state"  


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

# I select the columns that are all related to rgb in current stage.

rgb_s <- rgb[,.(col_num  = col_num,
                treat_ID_full, red_day1, red_day11, red_delta, red_percent_change)]

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

pollution <- ifelse(split_extract_ID(rgb_s$treat_ID_full, 1) == 'N', 'Nitrate', 'Ammonium')
dose <- factor(split_extract_ID(rgb_s$treat_ID_full, 2), ordered = T, levels = c('0', '1.5', '5', '7.5', '10', '18'))
temp <- factor(split_extract_ID(rgb_s$treat_ID_full, 3), ordered = T, levels = c('20', '30'))
feed <- ifelse(split_extract_ID(rgb_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(rgb_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

# lapply(list(pollution,dose, temp, feed, symbiont), function(x) sum(is.na(x))) Check missing

rgb_s[, `:=`(pollution = pollution,
             dose = dose,
             temp = temp, 
             feed = feed, 
             symbiont = symbiont,
             rgb_status = ifelse(red_delta > 0, 'bleached', 'browned'))]

# rm(list = c('pollution', 'dose', 'feed', 'temp', 'symbiont'))


# dose issue --------------------------------------------------------------

# So we were told that there are only four kinds of dose, but in fact we found 6 types in data.
# from other code we know: CNTRL_0="Control", A_5="Ambient", A_7.5="Intermediate", A_10="High")

nrow(rgb_s[dose %in% c('0', '5', '7.5', '10'),]) # 705
length(table(rgb_s[dose %in% c('0', '5', '7.5', '10'), treat_ID_full])) # 48

# At this step, we decided to keep all the values for further analysis


# Data Cleansing ----------------------------------------------------------

removeOutliers <- function(data){
  Q1 <- quantile(data, 0.25)
  Q3 <- quantile(data, 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  return(list(Check = data <= lower_bound | data >= upper_bound, res = data[data >= lower_bound & data <= upper_bound]))
}

# Add outliers Label (Nov 1st update)
rgb_s[, PercOutliersCheck := removeOutliers(rgb_s$rgb_percent_change)[['Check']]]

# Adjsut Dose Levels 

## Nitrate 
## 0 (control)
## 1.5 (low)
## 5 (medium)
## 18 (high)
## 
## Ammonium
## 0 (control)
## 5 (low)
## 7.5 (medium)
## 10 (high)

rgb_s[, dose_level := fcase(pollution == 'Nitrate' & dose == '0' , 'control-0',
                            pollution == 'Nitrate' & dose == '1.5' , 'Low',
                            pollution == 'Nitrate' & dose == '5' , 'Medium',
                            pollution == 'Nitrate' & dose == '18' , 'High',
                            pollution == 'Ammonium' & dose == '0' , 'control-0',
                            pollution == 'Ammonium' & dose == '5' , 'Low',
                            pollution == 'Ammonium' & dose == '7.5' , 'Medium',
                            pollution == 'Ammonium' & dose == '10' , 'High',
                            default = NA_character_)]

# Create new treatment ID:
rgb_s[, new_treat_ID_full := str_c(pollution, dose_level, temp, feed, symbiont, sep = "_")]

write_csv(rgb_s, 'C:/Users/carol/OneDrive/Documents/PhD Boston University 2019-/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/data/rgb_s.csv')


# data manipulation -------------------------------------------------------


rgb_s <- read_csv('C:/Users/carol/OneDrive/Documents/PhD Boston University 2019-/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/data/rgb_s.csv')
rgb_s <- as.data.table(rgb_s)

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 4)

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

create_columns(rgb_s, twoComb)
create_columns(rgb_s, threeComb)
create_columns(rgb_s, fourComb)

nitrate <- rgb_s[pollution == 'Nitrate',]
ammonium <- rgb_s[pollution == 'Ammonium']

write_csv(rgb_s, 'C:/Users/carol/OneDrive/Documents/PhD Boston University 2019-/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/data/rgb_all_combinations_columns.csv')

