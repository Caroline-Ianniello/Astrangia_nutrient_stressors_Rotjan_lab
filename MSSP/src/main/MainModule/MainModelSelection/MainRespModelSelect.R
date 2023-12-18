
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

nitrate_resp_rate_MSE_arr <- load('MSSP/data/Cross-Validation-Results/MSE-Arrays/nitrate_resp_MSE_arr.RDS')
ammonium_resp_rate_MSE_arr <- load('MSSP/data/Cross-Validation-Results/MSE-Arrays/ammonium_resp_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

nitrate_resp_best_lambda <- find_best_tune(nitrate_resp_rate_MSE_arr)
ammonium_resp_best_lambda <- find_best_tune(ammonium_resp_rate_MSE_arr)


# write the result to external file ---------------------------------------

record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Nitrate-Respiration-CV-Summary.md', 
              model_response = 'Respiration-Rate', 
              pollution_type = 'nitrate', 
              MSE_array = nitrate_resp_best_lambda)

record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Ammonium-Respiration-CV-Summary.md', 
              model_response = 'Respiration-Rate', 
              pollution_type = 'ammonium', 
              MSE_array = ammonium_resp_best_lambda)

