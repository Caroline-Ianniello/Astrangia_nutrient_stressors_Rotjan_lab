setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
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

load('MSSP/data/Cross-Validation-Results/MSE-Arrays/resp_MSE_arr.RDS')

# average MSE for each lambda ---------------------------------------------

resp_best_lambda <- find_best_tune(resp_MSE_arr)



# write the result to external file ---------------------------------------

record_lambda(file = 'MSSP/doc/Analysis-Log/Cross-Validation-Results/Respiration-CV-Summary.md', 
              model_response = 'Respiration-Rate', 
              pollution_type = 'nitrate', 
              MSE_array = resp_MSE_arr)

