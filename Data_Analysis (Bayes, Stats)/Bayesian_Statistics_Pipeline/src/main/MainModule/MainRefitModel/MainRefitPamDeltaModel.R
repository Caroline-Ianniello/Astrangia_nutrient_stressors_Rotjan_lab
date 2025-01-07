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


# Load Data and best Lambda -----------------------------------------------

pam_model <- read_csv('MSSP/data/ProcessedData/PAM_all_combinations_columns.csv')
pam_model$temp <- factor(pam_model$temp, levels = c(20, 29))
pam_model$dose_level <- relevel(factor(pam_model$dose_level), ref = 'Low')


# load MSE_array object 

load('MSSP/data/Cross-Validation-Results/MSE-Arrays/pam_delta_MSE_arr.RDS')

# average MSE for each lambda

pamdelta_best_lambda <- find_best_tune(pam_delta_MSE_arr)

print(pamdelta_best_lambda) # 4.436909


# Refit -------------------------------------------------------------------

set.MC.cores(4)

PAM_delta_lasso <- refitRstanLasso(data = pam_model,
                                   formula = as.formula('PAM_delta ~ (dose_level + temp + feed + symbiont)^4 + (1|col_num)'),
                                   best_lambda = pamdelta_best_lambda,
                                   iter = 4000, 
                                   autoscale = TRUE)


# export the model --------------------------------------------------------

save(PAM_delta_lasso, file = 'MSSP/data/Refit-Models/PAM-Delta/PAM_delta_lasso.RDS')
