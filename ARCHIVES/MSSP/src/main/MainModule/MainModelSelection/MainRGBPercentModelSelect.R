
source('MSSP/src/main/model-evaluation/ModelSelect.r')

# find_best_tune
  # Find the best lambda for refitting model with entire dataset
  #=====
  # MSE_array: <array dim(l,k,2)> 
  # which_MSE: <string> 'both'/'train'/'valid', default = 'both'
  # return:
  ## which_MSE == 'both' : <vector> best lambda vector
  ## which_MSE == 'train'/'valid' : <float> best lambda value


# load MSE_array object ---------------------------------------------------

nitrate_rgb_percchange_MSE_arr <- load('MSSP/data/MSE-Arrays/nitrate_rgb_percchange_MSE_arr.RDS')
ammonium_rgb_percchange_MSE_arr <- load('MSSP/data/MSE-Arrays/ammonium_rgb_percchange_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_rgbperc_best_lambda <- find_best_tune(nitrate_rgb_percchange_MSE_arr)
ammonium_rgbperc_best_lambda <- find_best_tune(ammonium_rgb_percchange_MSE_arr)


# write the result to external file ---------------------------------------

record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Nitrate-rgb-Percent-Change-CV-Summary.md', model_response = 'rgb_percent_change', pollution_type = 'nitrate', MSE_array = nitrate_rgb_percchange_MSE_arr)
record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Ammonium-rgb-Percent-Change-CV-Summary.md', model_response = 'rgb_percent_change', pollution_type = 'ammonium', MSE_array = ammonium_rgb_percchange_MSE_arr)









# old version -------------------------------------------------------------
# 
# 
# performance_metrics_nitrate_percent <- calculate_performance_metrics(nitrate_percent_change_fit, nitrate)
# 
# best_lambda_nitrate_percent=find_best_lambda(performance_metrics_nitrate_percent)
# best_lambda_nitrate_percent
# 
# 
# performance_metrics_ammonium_percent <- calculate_performance_metrics(ammonium_percent_change_fit, ammonium)
# 
# best_lambda_ammonium_percent=find_best_lambda(performance_metrics_ammonium_percent)
# best_lambda_ammonium_percent