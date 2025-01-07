
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

nitrate_rgb_delta_MSE_arr <- load('MSSP/data/MSE-Arrays/nitrate_rgb_delta_MSE_arr.RDS')
ammonium_rgb_delta_MSE_arr <- load('MSSP/data/MSE-Arrays/ammonium_rgb_delta_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_rgbdelta_best_lambda <- find_best_tune(nitrate_rgb_delta_MSE_arr)
ammonium_rgbdelta_best_lambda <- find_best_tune(ammonium_rgb_delta_MSE_arr)


# write the result to external file ---------------------------------------

record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Nitrate-rgb-Delta-CV-Summary.md', model_response = 'rgb_delta', pollution_type = 'Nitrate', MSE_array = nitrate_rgb_delta_MSE_arr)
record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Ammonium-rgb-Delta-CV-Summary.md', model_response = 'rgb_delta', pollution_type = 'Ammonium', MSE_array = ammonium_rgb_delta_MSE_arr)
