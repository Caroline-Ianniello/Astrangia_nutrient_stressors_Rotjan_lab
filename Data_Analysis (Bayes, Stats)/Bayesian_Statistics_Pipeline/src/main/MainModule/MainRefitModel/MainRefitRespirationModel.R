setwd('/projectnb/rotjanlab/git-repo-denny') # SCC
source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')
source('MSSP/src/main/model-evaluation/ModelSelect.r')

# Documentation -----------------------------------------------------------

# refitRstanLasso
# function(data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0, adapt_delta = NULL, QR = FALSE, sparse = FALSE)
# This function fits a Mixed Effects Lasso Bayesian Regression model using a specified lambda regularization parameter (best_lambda).
# The model refits a full lasso model after estimating a null model with only the intercept.
# ===
# data: A data frame containing the variables specified in the formula.
# formula: An object of class formula (or one that can be coerced to that class): a symbolic description of the model to be fitted.
# best_lambda: The optimal value of the regularization parameter lambda used for the lasso regression.
# location: A numeric value specifying the location parameter for the Laplace distribution. Default is 0.
# chains: The number of Markov Chain Monte Carlo (MCMC) chains to run. Default is 4.
# iter: The number of iterations to perform in each MCMC chain. Default is 2000.
# refresh: The frequency of displayed output on the console during sampling. Set to 0 for no output. Default is 1.
# adapt_delta: A numeric value specifying the target average proposal acceptance probability during the adaptation period of the Hamiltonian Monte Carlo (HMC) sampling. This argument is optional.
# QR: A logical value indicating whether to apply a scaled QR decomposition to the design matrix. If TRUE, helps to improve the numerical stability of the model fitting. Default is FALSE.
# sparse: A logical value indicating whether to use a sparse representation of the design matrix X. Sparse representations can lead to improvements in computational efficiency for large datasets. Default is FALSE.
# ===
# Return A list containing the following components:
#   - Null_model: The fitted null model with only the intercept.
#   - BestRefit: The fitted lasso model using the specified best_lambda.
# ===

# load data ---------------------------------------------------------------

resp_model <- read_csv('MSSP/data/ProcessedData/Respiration_all_combinations_columns.csv')

# temperature will be seen as a numeric column after reloading the data
resp_model$temp <- factor(resp_model$temp, levels = c(20, 29))
resp_model$e_coli <- factor(resp_model$e_coli)
resp_model$dose_level <- relevel(factor(resp_model$dose_level), ref = 'Low')

# load MSE_array object 

load('MSSP/data/Cross-Validation-Results/MSE-Arrays/resp_MSE_arr.RDS')

# average MSE for each lambda

resp_best_lambda <- find_best_tune(resp_MSE_arr) 
print(resp_best_lambda) # 1.007505


# Refit -------------------------------------------------------------------

set.MC.cores(4)

Resp_lasso <- refitRstanLasso(data = resp_model,
                              formula = as.formula('abs_resp_rate_SA_corr ~ (dose_level + temp + feed + symbiont + e_coli)^5 + (1|col_num)'),
                              best_lambda = resp_best_lambda, 
                              iter = 4000, 
                              autoscale = TRUE)



# export the model --------------------------------------------------------

save(Resp_lasso, file = 'MSSP/data/Refit-Models/Respiration/Resp_lasso.RDS')



