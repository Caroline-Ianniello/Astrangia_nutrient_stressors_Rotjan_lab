
# Library -----------------------------------------------------------------

pacman::p_load(tidyverse, data.table)


# Load Data ---------------------------------------------------------------
setwd('/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals')
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

pam_s <- PAM[,.(col_num_16 = col_num...16, col_num_3 = col_num...3,
                treat_ID_full, PAM_avg_day1, PAM_avg_day11, PAM_delta, pam_percent_change, log_PAM_delta)]

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

pollution <- ifelse(split_extract_ID(pam_s$treat_ID_full, 1) == 'N', 'Nitrate', 'Ammonium')
dose <- factor(split_extract_ID(pam_s$treat_ID_full, 2), ordered = T, levels = c('0', '1.5', '5', '7.5', '10', '18'))
temp <- factor(split_extract_ID(pam_s$treat_ID_full, 3), ordered = T, levels = c('20', '30'))
feed <- ifelse(split_extract_ID(pam_s$treat_ID_full, 4) == 'F', 'Fed', 'Starved')
symbiont <- ifelse(split_extract_ID(pam_s$treat_ID_full, 5) == 'S', 'Symbiotic', 'Aposymbiotic')

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

# Add outliers Label (Nov 1st update)
pam_s[, PercOutliersCheck := removeOutliers(pam_s$pam_percent_change)[['Check']]]

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

pam_s[, dose_level := fcase(pollution == 'Nitrate' & dose == '0' , 'control-0',
                            pollution == 'Nitrate' & dose == '1.5' , 'Low',
                            pollution == 'Nitrate' & dose == '5' , 'Medium',
                            pollution == 'Nitrate' & dose == '18' , 'High',
                            pollution == 'Ammonium' & dose == '0' , 'control-0',
                            pollution == 'Ammonium' & dose == '5' , 'Low',
                            pollution == 'Ammonium' & dose == '7.5' , 'Medium',
                            pollution == 'Ammonium' & dose == '10' , 'High',
                            default = NA_character_)]

# Create new treatment ID:
pam_s[, new_treat_ID_full := str_c(pollution, dose_level, temp, feed, symbiont, sep = "_")]

write_csv(pam_s, 'MSSP/data/pam_s.csv')
# EDA ---------------------------------------------------------------------


# EDA - Univariate --------------------------------------------------------

# denominator -------------------------------------------------------------

# Since we are interested in the percentage change, followed the concern that the denominator might have huge impact on the percentage change
png('Denny/image/prelimEDA/denominatorAll.png', bg = 'transparent', width = 1080, height = 480)
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
png('Denny/image/prelimEDA/denominator-RmOutliers.png', bg = 'transparent', width = 480, height = 480)
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
png('Denny/image/prelimEDA/denominator-Outliers.png', bg = 'transparent', width = 480, height = 480)
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
png('Denny/image/prelimEDA/pollutionType-RmOutliers-FacetWrap-doseLevel.png', bg = 'transparent', width = 960, height = 480)
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
  facet_wrap(facets = vars(dose_level))
dev.off()

## 
png('Denny/image/prelimEDA/pollutionType-RmOutliers.png', bg = 'transparent', width = 480, height = 480)
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
  coord_flip() 
dev.off()

png('Denny/image/prelimEDA/pollutionType-Outliers.png', bg = 'transparent', width = 480, height = 480)
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


## pollution type to pam_status (∆PAM increase/decrease).
png('Denny/image/prelimEDA/pollutionTypeToDirection.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[, .N, .(pollution, pam_status)]) +
  # geom_bar(aes(x = pollution, y = N, fill = pam_status), stat = 'identity', position = 'dodge') +
  geom_col(aes(pollution, N, fill = pam_status), position = "dodge") +
  geom_text(aes(x = pollution, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
  ggtitle('Pollution to PAM increase/decrease') +
  ylab('Obs Count') +
  scale_fill_discrete(name = 'Change in PAM') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         text = element_text(size = 14))
dev.off()

## temperature to PAM ∆%
png('Denny/image/prelimEDA/temperatureToDirection.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[, .N, .(temp, pam_status)]) +
  # geom_bar(aes(x = pollution, y = N, fill = pam_status), stat = 'identity', position = 'dodge') +
  geom_col(aes(temp, N, fill = pam_status), position = "dodge") +
  geom_text(aes(x = temp, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
  ggtitle('Temperature to PAM increase/decrease') +
  ylab('Obs Count') +
  scale_fill_discrete(name = 'Change in PAM') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         text = element_text(size = 14))
dev.off()
# Dose_Level --------------------------------------------------------------

png('Denny/image/prelimEDA/doseLevelToDirection.png', bg = 'transparent', width = 720, height = 480)
ggplot(pam_s[, .N, .(dose_level, pam_status)]) +
  # geom_bar(aes(x = pollution, y = N, fill = pam_status), stat = 'identity', position = 'dodge') +
  geom_col(aes(dose_level, N, fill = pam_status), position = "dodge") +
  geom_text(aes(x = dose_level, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
  ggtitle('Dose Level to PAM increase/decrease') +
  ylab('Obs Count') +
  scale_fill_discrete(name = 'Change in PAM') +
  scale_x_discrete(limits = c('control-0', 'Low', 'Medium', 'High')) +
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

png('Denny/image/prelimEDA/doseLevelToDirection-Box.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == F,]) +
  geom_boxplot(aes(x = dose_level, y = pam_percent_change, color = dose_level), size = 1.5, show.legend = FALSE) +
  ggtitle('Dose Level on Pollution Type (Rm Outliers)') +
  xlab('Dose Leve') + 
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


# Dose-Level Cross Boxplot ------------------------------------------------

nitrate_data <- subset(pam_s, pollution == "Nitrate")
ammonia_data <- subset(pam_s, pollution == "Ammonia")

# 绘制 Nitrate 子集的箱线图
nitrate_plot <- ggplot(nitrate_data, aes(x=dose, y=pam_percent_change)) +
  geom_boxplot(aes(fill=dose)) +
  theme_minimal() +
  labs(title="Nitrate: Dose vs. Pam Percent Change", y="Pam Percent Change") +
  scale_fill_brewer(palette="Set1", name="Dose Levels")+
  theme_minimal() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'))
# 绘制 Ammonia 子集的箱线图
ammonia_plot <- ggplot(ammonia_data, aes(x=dose, y=pam_percent_change)) +
  geom_boxplot(aes(fill=dose)) +
  theme_minimal() +
  labs(title="Ammonia: Dose vs. Pam Percent Change", y="Pam Percent Change") +
  scale_fill_brewer(palette="Set1", name="Dose Levels")+
  theme_minimal() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'))
# 显示图形
print(nitrate_plot)
print(ammonia_plot)

library(gridExtra)


png('C:/Users/10495/Desktop/consulting/Consulting1/p3.png', bg = 'transparent', width = 720, height = 670)

grid.arrange(nitrate_plot, ammonia_plot, ncol=1)
dev.off()


# Dose_Level Cross Heatmap ------------------------------------------------

# Feed x Dose
nitrate_feed <- nitrate_data %>%
  group_by(feed, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

nitrate_feed_plot <- ggplot(nitrate_feed, aes(x=feed, y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Nitrate: Feed x Dose Interaction Heatmap") +
  theme_minimal()+
  coord_equal()

print(nitrate_feed_plot)

# Symbiont x Dose
nitrate_symbiont <- nitrate_data %>%
  group_by(symbiont, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

nitrate_symbiont_plot <- ggplot(nitrate_symbiont, aes(x=abbreviate(symbiont), y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Nitrate: Symbiont x Dose Interaction Heatmap") +
  
  theme_minimal()+
  coord_equal()

print(nitrate_symbiont_plot)

# Temp x Dose
nitrate_temp <- nitrate_data %>%
  group_by(temp, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

nitrate_temp_plot <- ggplot(nitrate_temp, aes(x=temp, y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Nitrate: Temp x Dose Interaction Heatmap") +
  theme_minimal()+
  coord_equal()

print(nitrate_temp_plot)

# 对于 Ammonia 数据集

# Feed x Dose
ammonia_feed <- ammonia_data %>%
  group_by(feed, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

ammonia_feed_plot <- ggplot(ammonia_feed, aes(x=feed, y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Ammonia: Feed x Dose Interaction Heatmap") +
  theme_minimal()+
  coord_equal()

print(ammonia_feed_plot)

# Symbiont x Dose
ammonia_symbiont <- ammonia_data %>%
  group_by(symbiont, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

ammonia_symbiont_plot <- ggplot(ammonia_symbiont, aes(x=abbreviate(symbiont), y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Ammonia: Symbiont x Dose Interaction Heatmap") +
  theme_minimal()+
  coord_equal()

print(ammonia_symbiont_plot)

# Temp x Dose
ammonia_temp <- ammonia_data %>%
  group_by(temp, dose) %>%
  summarise(mean_pam_percent_change = mean(pam_percent_change, na.rm=TRUE))

ammonia_temp_plot <- ggplot(ammonia_temp, aes(x=temp, y=dose, fill=mean_pam_percent_change)) +
  geom_tile() +
  scale_fill_viridis_c(name="Mean Pam Percent Change") +
  labs(title="Ammonia: Temp x Dose Interaction Heatmap") +
  theme_minimal()+ coord_equal()

print(ammonia_temp_plot)

# Temperature -------------------------------------------------------------
png('Denny/image/prelimEDA/tempRmOutliersBox.png', bg = 'transparent', width = 480, height = 480)
ggplot(pam_s[PercOutliersCheck == F,]) +
  geom_boxplot(aes(x = temp, y = pam_percent_change, color = temp), size = 1.5, show.legend = FALSE) +
  ggtitle('Temperature on Pollution Type (Rm Outliers)') +
  xlab('Temperature') + 
  ylab('PAM Percent Change') +
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
dev.off()

png('Denny/image/prelimEDA/Temp2PamRmOutliersScatter.png', bg = 'transparent', width = 540, height = 480)
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
dev.off()

png('Denny/image/prelimEDA/temperatureToDirection')
ggplot(pam_s[, .N, .(temp, pam_status)]) +
  geom_col(aes(x = temp, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = temp, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  xlab('Temp') +
  ylab('Obs Count') +
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

# Feed --------------------------------------------------------------------
png('Denny/image/prelimEDA/feed2PamRmOutliersBox.png', bg = 'transparent', width = 1080, height = 240)
ggplot(pam_s[PercOutliersCheck == F,]) +
  geom_boxplot(aes(x = feed, y = pam_percent_change, color = feed), size = 1.5, show.legend = FALSE) +
  ggtitle('Feed on Pollution Type (Rm Outliers)') +
  xlab('Feed') + 
  ylab('PAM Percent Change') +
  scale_color_manual(values = c("Fed" = "blue", "Starved" = "orange")) +
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

png('Denny/image/prelimEDA/feed2PamRmOutliersScatter.png', bg = 'transparent', width = 540, height = 480)
ggplot(pam_s) +
  geom_segment(aes(x = 0.55, y = 0.15, xend = 0.16, yend = 0.6), arrow = arrow(length = unit(0.75, "cm")), color = 'darkgrey') +
  geom_text(aes(x = 0.1, y =0.65), label = 'increase', alpha = .5, size = 6) + 
  geom_text(aes(x = 0.6, y = 0.1), label = 'decrease', alpha = .5, size = 6) +
  geom_point(aes(x = PAM_avg_day1, y= PAM_avg_day11, color = feed), alpha = 0.75) +
  scale_color_manual(values = c("Fed" = "blue", "Starved" = "orange"), name = 'Feed') +
  xlab('Day 1 Average PAM') +
  ylab('Day 11 Average PAM') +
  ggtitle('Feed Status to Average PAM') +
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

png('Denny/image/prelimEDA/feedToDirection.png', bg = 'transparent', width = 720, height = 480)
ggplot(pam_s[, .N, .(feed, pam_status)]) +
  geom_col(aes(x = feed, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = feed, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Feed Status to PAM Change Direction') +
  xlab('Feed') +
  ylab('Obs Count') +
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

### There is no obvious difference between feed status


# EDA - 2 factors ---------------------------------------------------------

# Symbiont x Feed ---------------------------------------------------------

png('Denny/image/prelimEDA/SymxFeedToDirection.png', bg = 'transparent', width = 1080, height = 480)
ggplot(pam_s[, .(sym_feed = str_c(symbiont, feed, sep = '-'), pam_status)][, .N, .(sym_feed, pam_status)]) +
  geom_col(aes(x = sym_feed, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = sym_feed, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9)) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Symbiont x Feed to PAM Change Direction') +
  xlab('Symbiont x Feed') +
  ylab('Obs Count') +
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
  
# It is interesting that increasing records in Aposymbiotic combines with Starved has almost two times of the data count compared with decrease.



# Temp x Feed -------------------------------------------------------------

png('Denny/image/prelimEDA/Sym-x-FeedToDirection.png', bg = 'transparent', width = 540, height = 480)
ggplot(pam_s[, .(temp_feed = str_c(temp, feed, sep = '-'), pam_status)][, .N, .(temp_feed, pam_status)]) +
  geom_col(aes(x = temp_feed, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = temp_feed, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Temperature x Feed to PAM Change Direction') +
  xlab('Temp x Feed') +
  ylab('Obs Count') +
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

# 30˙C and Fed: decrease count > increase count

# Symbiont x Temp ---------------------------------------------------------

png('Denny/image/prelimEDA/Sym-x-TempToDirection.png', bg = 'transparent', width = 540, height = 480)
ggplot(pam_s[, .(temp_sym = str_c(temp, symbiont, sep = '-'), pam_status)][, .N, .(temp_sym, pam_status)]) +
  geom_col(aes(x = temp_sym, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = temp_sym, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Temperature x Symbiont to PAM Change Direction') +
  xlab('Temp x Symbiont') +
  ylab('Obs Count') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14),
         axis.text.x = element_text(angle = 45, vjust = 0.5))
dev.off()

# 20 and Aposymbiotic has a huge difference in PAM change direction

# Pollution x Temp --------------------------------------------------------

png('Denny/image/prelimEDA/Pollu-x-TempToDirection.png', bg = 'transparent', width = 540, height = 480)
ggplot(pam_s[, .(pollu_temp = str_c(pollution, temp, sep = '-'), pam_status)][, .N, .(pollu_temp, pam_status)]) +
  geom_col(aes(x = pollu_temp, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = pollu_temp, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Pollution x Temperature to PAM Change Direction') +
  xlab('Pollution x Temperature') +
  ylab('Obs Count') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14),
         axis.text.x = element_text(angle = 45, vjust = 0.5))
dev.off()

# Pollution x Feed --------------------------------------------------------

png('Denny/image/Pollu-x-FeedToDirection.png', bg = 'transparent', width = 1080, height = 480)
ggplot(pam_s[, .(pollu_feed = str_c(pollution, feed, sep = '-'), pam_status)][, .N, .(pollu_feed, pam_status)]) +
  geom_col(aes(x = pollu_feed, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = pollu_feed, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Pollution x Feed to PAM Change Direction') +
  xlab('Pollution x Feed') +
  ylab('Obs Count') +
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
### No interesting found.

# EDA - 3 factors ---------------------------------------------------------
# 
# # Symbiont x Temp x Feed --------------------------------------------------
# 
png('Denny/image/prelimEDA/Sym-x-Temp-x-FeedToDirection.png', bg = 'transparent', width = 1080, height = 480)
ggplot(pam_s[, .(symTempFeed = str_c(symbiont, temp, feed, sep = '-'), pam_status)][, .N, .(symTempFeed, pam_status)]) +
  geom_col(aes(x = symTempFeed, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = symTempFeed, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Symbiont x Temperature x Feed to PAM Change Direction') +
  xlab('Symbiont x Temperature x Feed') +
  ylab('Obs Count') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14),
         axis.text.x = element_text(angle = 45, vjust = 0.5))
dev.off()
# 
# # Symbiont x Temp x Pollution --------------------------------------------------
# 
png('Denny/image/prelimEDA/Sym-x-Temp-x-PolluToDirection.png', bg = 'transparent', width = 1080, height = 480)
ggplot(pam_s[, .(symTempPollu = str_c(symbiont, temp, pollution, sep = '-'), pam_status)][, .N, .(symTempPollu, pam_status)]) +
  geom_col(aes(x = symTempPollu, y = N, fill = pam_status), position = 'dodge') +
  geom_text(aes(x = symTempPollu, y = N, label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 6) +
  scale_fill_discrete(name = 'PAM Change Dir') +
  ggtitle('Symbiont x Temperature x Pollution  to PAM Change Direction') +
  xlab('Symbiont x Temperature x Pollution') +
  ylab('Obs Count') +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'),
         axis.text = element_text(size = 14),
         text = element_text(size = 14),
         axis.text.x = element_text(angle = 45, vjust = 0.5))
dev.off()
# 
# 

# Final Conclusion --------------------------------------------------------

######
# As we increase the component in the combination of the treatment, we can see that the difference in data count between two PAM change directions.
# 
# But a single variable in univariate analysis doesn't show too much strong effect on PAM changing.
#
# I think it will be something important when we are designing the regression in the future regarding to the interaction between treatments.
######



# Automatic Factors Combination Plots Generation --------------------------

# -- barplot pam change direction -- --------------------------------------

generate_barplots <- function(data, combinations, filepath) {

  for (i in 1:ncol(combinations)) {
    
    factors <- as.character(combinations[, i])
    
    # Create a new factor by concatenating the values of the current combination
    # tmp <- data[, .(combined_factor = str_c(!!!syms(factors), sep = '-'), pam_status)][, .N, .(combined_factor, pam_status)]
    tmp <- data %>%
      mutate(combined_factor = str_c(!!!syms(factors), sep = '-')) %>%
      group_by(combined_factor, pam_status) %>%
      summarise(N = n(), .groups = 'drop')

    p <- ggplot(tmp, aes(x = combined_factor, y = N, fill = pam_status)) +
      geom_col(position = 'dodge') +
      geom_text(aes(label = N, group = pam_status), vjust = -0.2, position = position_dodge(width = .9), size = 5) +
      scale_fill_discrete(name = 'PAM Change Dir') +
      ggtitle(paste(factors, collapse = ' x '), 'to PAM Change Direction') +
      xlab(paste(factors, collapse = ' x ')) +
      ylab('Obs Count') +
      theme_bw() +
      theme(axis.text = element_text(size = 14),
            text = element_text(size = 14),
            axis.text.x = element_text(angle = 45, vjust = 0.5))
    # +
    #   theme(panel.background = element_rect(fill='transparent'),
    #         plot.background = element_rect(fill='transparent', color=NA),
    #         panel.grid.major = element_blank(),
    #         panel.grid.minor = element_blank(),
    #         legend.background = element_rect(fill='transparent'),
    #         legend.box.background = element_rect(fill='transparent'),
    #         axis.text = element_text(size = 14),
    #         text = element_text(size = 14),
    #         axis.text.x = element_text(angle = 45, vjust = 0.5))
    
    filename <- paste(factors, collapse = 'x')
    exportpath <- paste(filepath, filename, '.png', sep = '', collapse = NULL)
    # Export
    if (grepl('four', filepath)){
      png(exportpath, bg = 'transparent', width = 1280, height = 480)  
    }
    else if (grepl('five', filepath)){
      png(exportpath, bg = 'transparent', width = 1580, height = 480)  
    }
    else{
      png(exportpath, bg = 'transparent', width = 1080, height = 480)
    }
    
    print(p)
    dev.off()
  }
}

# 1 factors combination
allPossibleCombn1 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 1)
generate_barplots(pam_s, allPossibleCombn1, filepath = 'Denny/image/singleFactors/change-direction-barchart/')

# 2 factors combination
allPossibleCombn2 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 2)
generate_barplots(pam_s, allPossibleCombn2, filepath = 'Denny/image/doubleFactors/change-direction-barchart/')

# 3 factors combination
allPossibleCombn3 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 3)
generate_barplots(pam_s, allPossibleCombn3, filepath = 'Denny/image/tripleFactors/change-direction-barchart/')

# 4 factors combination
allPossibleCombn4 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 4)
generate_barplots(pam_s, allPossibleCombn4, filepath = 'Denny/image/fourFactors/change-direction-barchart/')

# 5 factors combination
allPossibleCombn5 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 5)
generate_barplots(pam_s, allPossibleCombn5, filepath = 'Denny/image/fiveFactors/change-direction-barchart/')




# -- boxplot pam_percent_change rm outliers -- ----------------------------

generate_boxplots <- function(data, combinations, filepath) {

  for (i in 1:ncol(combinations)) {
    
    factors <- as.character(combinations[, i])
    
    # Create a new factor by concatenating the values of the current combination
    # tmp <- data[, .(combined_factor = str_c(!!!syms(factors), sep = '-'), pam_status)][, .N, .(combined_factor, pam_status)]
    tmp <- data %>%
      filter(PercOutliersCheck == F) %>%
      mutate(combined_factor = str_c(!!!syms(factors), sep = '-')) %>%
      select(combined_factor, pam_percent_change) 

    p <- ggplot(tmp, aes(x = combined_factor, y = pam_percent_change)) +
      geom_boxplot(aes(color = combined_factor), size = 1.5, show.legend = FALSE) +
      ggtitle(paste(factors, collapse = ' x '), 'to PAM Percent Change') +
      xlab(paste(factors, collapse = ' x ')) +
      ylab('PAM Percent Change') +
      theme_bw() +
      theme(axis.text = element_text(size = 14),
            text = element_text(size = 14),
            axis.text.x = element_text(angle = 45, vjust = 0.5))
    # +
    #   theme(panel.background = element_rect(fill='transparent'),
    #         plot.background = element_rect(fill='transparent', color=NA),
    #         panel.grid.major = element_blank(),
    #         panel.grid.minor = element_blank(),
    #         legend.background = element_rect(fill='transparent'),
    #         legend.box.background = element_rect(fill='transparent'),
    #         axis.text = element_text(size = 14),
    #         text = element_text(size = 14),
    #         axis.text.x = element_text(angle = 45, vjust = 0.5))
    
    filename <- paste(factors, collapse = 'x')
    exportpath <- paste(filepath, filename, '.png', sep = '', collapse = NULL)
    # Export
    if (grepl('four', filepath)){
      png(exportpath, bg = 'transparent', width = 1280, height = 480)
    }
    else if (grepl('five', filepath)){
      png(exportpath, bg = 'transparent', width = 1580, height = 480)
    }
    else{
      png(exportpath, bg = 'transparent', width = 1080, height = 480)
    }

    print(p)
    dev.off()
  }
}


# 1 factors combination
allPossibleCombn1 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 1)
generate_boxplots(pam_s, allPossibleCombn1, filepath = 'Denny/image/singleFactors/percent-change-boxplot/')

# 2 factors combination
allPossibleCombn2 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 2)
generate_boxplots(pam_s, allPossibleCombn2, filepath = 'Denny/image/doubleFactors/percent-change-boxplot/')

# 3 factors combination
allPossibleCombn3 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 3)
generate_boxplots(pam_s, allPossibleCombn3, filepath = 'Denny/image/tripleFactors/percent-change-boxplot/')

# 4 factors combination
allPossibleCombn4 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 4)
generate_boxplots(pam_s, allPossibleCombn4, filepath = 'Denny/image/fourFactors/percent-change-boxplot/')

# 5 factors combination
allPossibleCombn5 <- combn(c('pollution', 'dose_level', 'temp', 'feed', 'symbiont'), 5)
generate_boxplots(pam_s, allPossibleCombn5, filepath = 'Denny/image/fiveFactors/percent-change-boxplot/')


# std on pam_percent_change -----------------------------------------------

pam_s[PercOutliersCheck == F, .(std = sd(pam_percent_change))] #  std: 0.473015
pam_s[, .(std = sd(pam_percent_change))] #  std: 2.128053
































































# 
ggplot(data = melt(pam_s[,.(avgPAM_avg_day1 = mean(PAM_avg_day1), avgPAM_avg_day11 = mean(PAM_avg_day11), pam_status, new_treat_ID_full), new_treat_ID_full],
     id.vars = c('new_treat_ID_full', 'pam_status'), measure.vars = c('avgPAM_avg_day1', 'avgPAM_avg_day11'))) +
  geom_point(aes(x = variable, y = value, group = new_treat_ID_full, color = new_treat_ID_full), show.legend = F) +
  geom_line(aes(x = variable, y = value, group = new_treat_ID_full, color = new_treat_ID_full)) +
  theme_bw() +
  theme( panel.background = element_rect(fill='transparent'),
         plot.background = element_rect(fill='transparent', color=NA),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background = element_rect(fill='transparent'),
         legend.box.background = element_rect(fill='transparent'))








