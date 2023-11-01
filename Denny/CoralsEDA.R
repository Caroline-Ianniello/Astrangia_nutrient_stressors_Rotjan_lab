
# Library -----------------------------------------------------------------

pacman::p_load(tidyverse, data.table)


# Load Data ---------------------------------------------------------------

PAM <- read_csv('PAM_all_dead_deleted_all_controls_7_21_23.csv')

PAM <- as.data.table(PAM)


# data understanding ------------------------------------------------------

# Columns we got
#  [1] "date_coll"           "date_frag"           "col_num...3"         "frag_letter"         "col_frag_num"        "tile_num"           
#  [7] "tile_position"       "sym_state...8"       "exp_num"             "exp_subrun"          "stand_beetag"        "peg_beetag"         
# [13] "exp_1_beetag"        "exp_run_full"        "beetag_exprun"       "col_num...16"        "jar_unique_ID"       "temp...18"          
# [19] "PAM_avg_day1"        "PAM_avg_day11"       "PAM_delta"           "pam_percent_change"  "log_PAM_delta"       "treat_ID_full"      
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

# I select the columns that are all related to PAM in current stage.

pam_s <- PAM[,.(treat_ID_full, PAM_avg_day1, PAM_avg_day11, PAM_delta, pam_percent_change, log_PAM_delta)]

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

pollution <- ifelse(split_extract_ID(pam_s$treat_ID_full, 1) == 'N', 'Nitrate', 'Ammonia')
dose <- factor(split_extract_ID(pam_s$treat_ID_full, 2), ordered = T, levels = c('0', '1.5', '5', '7.5', '10', '18'))
temp <- factor(split_extract_ID(pam_s$treat_ID_full, 3), ordered = T, levels = c('20', '30'))
feed <- ifelse(split_extract_ID(pam_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(pam_s$treat_ID_full, 5) == 'S', 'symbiotic', 'Aposymbiotic')

# lapply(list(pollution,dose, temp, feed, symbiont), function(x) sum(is.na(x))) Check missing

pam_s[, `:=`(pollution = pollution,
             dose = dose,
             temp = temp, 
             feed = feed, 
             symbiont = symbiont,
             pam_status = ifelse(PAM_delta > 0, 'increase', 'decrease'))]

# rm(list = c('pollution', 'dose', 'feed', 'temp', 'symbiont'))


# dose issue --------------------------------------------------------------

# So we were told that there are only four kinds of dose, but in fact we found 6 types in data.
# from other code we know: CNTRL_0="Control", A_5="Ambient", A_7.5="Intermediate", A_10="High")

nrow(pam_s[dose %in% c('0', '5', '7.5', '10'),]) # 705
length(table(pam_s[dose %in% c('0', '5', '7.5', '10'), treat_ID_full])) # 48

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

# Add outliers Lable
pam_s[, PercOutliersCheck := removeOutliers(pam_s$pam_percent_change)[['Check']]]
# EDA ---------------------------------------------------------------------


# denominator -------------------------------------------------------------

# Since we are interested in the percentage change, followed the concern that the denominator might have huge impact on the percentage change
png('Denny/denominatorAll.png', bg = 'transparent', width = 1080, height = 480)
ggplot(pam_s) +
  geom_point(aes(x = PAM_delta, y = pam_percent_change, color = PAM_avg_day11 - PAM_avg_day1), alpha = .75) +
  ggtitle('Check Denominator for Percentage Change') +
  ylab('PAM Percent Change') +
  xlab('∆PAM') +
  scale_color_gradient(low = "blue", high = "orange", name = 'Average PAM D11 - D1') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14))
dev.off()

# check the data removing outliers
png('Denny/denominatorNotOutliers.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == F,]) +
  geom_point(aes(x = PAM_delta, y = pam_percent_change, color = PAM_avg_day11 - PAM_avg_day1), alpha = .75) +
  ggtitle('Check Denominator for Percentage Change (Rm Outliers)') +
  ylab('PAM Percent Change') +
  xlab('∆PAM') +
  scale_color_gradient(low = "blue", high = "orange", name = 'Average PAM D11 - D1') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14))
dev.off()
# check the rest of the data 
png('Denny/denominatorNotOutliers.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == T,]) +
  geom_point(aes(x = PAM_delta, y = pam_percent_change, color = PAM_avg_day11 - PAM_avg_day1), alpha = .75) +
  ggtitle('Check Denominator for Percentage Change (Outliers)') +
  ylab('PAM Percent Change') +
  xlab('∆PAM') +
  scale_color_gradient(low = "blue", high = "orange", name = 'Average PAM D11 - D1') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14))
dev.off()

# Intuitively, I decide to check all the univariate factors to our target variable (pam_percent_change)


# pollution ---------------------------------------------------------------

## pollution type to PAM percent change.
png('Denny/pollutiontypeRmOutliers.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == F, ]) +
  geom_boxplot(aes(x = pollution, y = pam_percent_change, color = pollution), size = 1.5, show.legend = FALSE) +
  ggtitle('PAM Percent Change on Pollution Type (Rm Outliers)') +
  ylab('PAM Percent Change') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14)) +
  coord_flip() +
  facet_wrap(facets = vars(dose))
dev.off()

png('Denny/pollutiontypeOutliers.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == T, ]) +
  geom_boxplot(aes(x = pollution, y = pam_percent_change, color = pollution), size = 1.5, show.legend = FALSE) +
  ggtitle('PAM Percent Change on Pollution Type (Outliers)') +
  ylab('PAM Percent Change') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14)) +
  coord_flip()
dev.off()

# ggplot(pam_s[between(pam_percent_change, -1, 1),]) +
#   geom_boxplot(aes(x = pollution, y = pam_percent_change, color = pollution), size = 1.5, show.legend = FALSE) +
#   ggtitle('Log(PAM Percent Change) on Pollution Type') +
#   ylab('Log of PAM Percent Change') +
#   theme_bw() +
#   theme( panel.background = element_rect(fill='transparent'),
#          plot.background = element_rect(fill='transparent', color=NA),
#          panel.grid.major = element_blank(),
#          panel.grid.minor = element_blank(),
#          legend.background = element_rect(fill='transparent'),
#          legend.box.background = element_rect(fill='transparent'),
#          text = element_text(size = 14)) +
#   coord_flip()

ggplot(pam_s[pam_percent_change > 1,]) +
  geom_boxplot(aes(x = pollution, y = pam_percent_change, color = pollution), size = 1.5, show.legend = FALSE) +
  ggtitle('Log(PAM Percent Change) on Pollution Type') +
  ylab('Log of PAM Percent Change') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14)) +
  coord_flip()

## pollution type to pam_status (∆PAM increase/decrease).
# ggplot(pam_s[, .N, .(pollution, pam_status)]) +
#   # geom_bar(aes(x = pollution, y = N, fill = pam_status), stat = 'identity', position = 'dodge') +
#   geom_col(aes(pollution, N, fill = pam_status), position = "dodge") +
#   geom_text(aes(x = pollution, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
#   ggtitle('Pollution to PAM increase/decrease') +
#   ylab('Obs Count') +
#   scale_fill_discrete(name = 'Change in PAM') +
#   theme_bw() +
#   theme( panel.background = element_rect(fill='transparent'),
#          plot.background = element_rect(fill='transparent', color=NA),
#          panel.grid.major = element_blank(),
#          panel.grid.minor = element_blank(),
#          legend.background = element_rect(fill='transparent'),
#          legend.box.background = element_rect(fill='transparent'),
#          text = element_text(size = 14))

## temperature to PAM ∆%
ggplot(pam_s[pam_percent_change <=5,]) +
  geom_boxplot(aes(x = temp, y = pam_percent_change, color = temp), size = 1.5, show.legend = FALSE) +
  ggtitle('Temperature on Pollution Type') +
  xlab('Temperature') + 
  ylab('Log of PAM Percent Change') +
  scale_color_manual(values = c("20" = "blue", "30" = "orange")) +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14)) +
  coord_flip()

# ggplot(pam_s[, .N, .(temp, pam_status)]) +
#   # geom_bar(aes(x = pollution, y = N, fill = pam_status), stat = 'identity', position = 'dodge') +
#   geom_col(aes(temp, N, fill = pam_status), position = "dodge") +
#   geom_text(aes(x = temp, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
#   ggtitle('Temperature to PAM increase/decrease') +
#   ylab('Obs Count') +
#   scale_fill_discrete(name = 'Change in PAM') +
#   theme_bw() +
#   theme( panel.background = element_rect(fill='transparent'),
#          plot.background = element_rect(fill='transparent', color=NA),
#          panel.grid.major = element_blank(),
#          panel.grid.minor = element_blank(),
#          legend.background = element_rect(fill='transparent'),
#          legend.box.background = element_rect(fill='transparent'),
#          text = element_text(size = 14))

# 
ggplot(pam_s) +
  geom_segment(aes(x = 0.55, y = 0.15, xend = 0.16, yend = 0.6), arrow = arrow(length = unit(0.75, "cm")), color = 'darkgrey') +
  geom_text(aes(x = 0.1, y =0.65), label = 'increase', alpha = .5, size = 6) + 
  geom_text(aes(x = 0.6, y = 0.1), label = 'decrease', alpha = .5, size = 6) +
  geom_point(aes(x = PAM_avg_day1, y= PAM_avg_day11, color = temp), alpha = 0.75) +
  scale_color_manual(values = c("20" = "blue", "30" = "orange"), name = 'Temperature') +
  xlab('Day 1 Average PAM') +
  ylab('Day 11 Average PAM') +
  ggtitle('Temparature to Average PAM') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14))

## dose:

ggplot(pam_s[, .(avg_percent_change = mean(PAM_delta) / mean(PAM_avg_day1)), by = .(dose, temp)]) +
  geom_tile(aes(x = dose, y = temp, fill = avg_percent_change)) +
  scale_fill_gradient(low = "blue", high = "orange", name = 'Average PAM ∆%')





















ggplot(data = melt(pam_s[,.(avgPAM_avg_day1 = mean(PAM_avg_day1), avgPAM_avg_day11 = mean(PAM_avg_day11), pam_status), treat_ID_full], 
     id.vars = c('treat_ID_full', 'pam_status'), measure.vars = c('avgPAM_avg_day1', 'avgPAM_avg_day11'))) +
  geom_line(aes(x = variable, y = value, group = treat_ID_full, color = pam_status)) +
  theme_minimal() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'))








