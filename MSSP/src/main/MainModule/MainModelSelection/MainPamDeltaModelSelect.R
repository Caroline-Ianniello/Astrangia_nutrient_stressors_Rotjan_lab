
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

nitrate_pam_delta_MSE_arr <- load('MSSP/data/MSE-Arrays/nitrate_pam_delta_MSE_arr.RDS')
ammonium_pam_delta_MSE_arr <- load('MSSP/data/MSE-Arrays/ammonium_pam_delta_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_pamdelta_best_lambda <- find_best_tune(nitrate_pam_delta_MSE_arr)
ammonium_pamdelta_best_lambda <- find_best_tune(ammonium_pam_delta_MSE_arr)


# write the result to external file ---------------------------------------

record_lambda(file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/Nitrate-PAM-Delta-CV-Summary.md', model_response = 'PAM_delta', pollution_type = 'Nitrate', MSE_array = nitrate_pam_delta_MSE_arr)
record_lambda(file = 'MSSP/data/Cross-Validation-Results/MSE-Arrays/Ammonium-PAM-Delta-CV-Summary.md', model_response = 'PAM_delta', pollution_type = 'Ammonium', MSE_array = ammonium_pam_delta_MSE_arr)
