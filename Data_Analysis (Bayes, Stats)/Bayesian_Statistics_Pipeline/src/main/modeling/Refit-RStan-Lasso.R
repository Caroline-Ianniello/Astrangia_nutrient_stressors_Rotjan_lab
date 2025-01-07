
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

# rstan_mixEff_lasso
  # Mixed Effect Lasso Bayesian Regression
  # ===
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # adapt_delta: <float> specify the  target average proposal acceptance probability during Stan's adaptation period. (when using HMC)
  # QR: <bool> if TRUE applies a scaled qr decomposition to the design matrix
  # sparse: <bool> A logical scalar (defaulting to FALSE) indicating whether to use a sparse representation of the design (X) matrix. 
  ## It is not possible to specify both QR = TRUE and sparse = TRUE.
  # ===



refitRstanLasso <- function(data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 1, adapt_delta = NULL, QR = FALSE, sparse = FALSE, autoscale = TRUE){
# refitRstanLasso
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
  # autoscale: <bool> A logical scalar (defaulting to FALSE) indicating whether the scale of the Laplace should be auto adjusted.
  # ===
  # Return A list containing the following components:
  #   - Null_model: The fitted null model with only the intercept.
  #   - BestRefit: The fitted lasso model using the specified best_lambda.
  # ===
  formula_parts <- strsplit(as.character(formula), "~")[[2]]
  null_formula <- as.formula(paste0(formula_parts, "~ 1"))
  
  # fit null model
  nullM <-  stan_glm(null_formula, data = data, chains = 2, iter = 1000, refresh = 0)
  
  fit <- rstan_mixEff_lasso(data, formula, location = 0, lambda = best_lambda, 
                            chains = chains, iter = iter, refresh = refresh, 
                            adapt_delta = adapt_delta, QR = QR, sparse = sparse, 
                            autoscale = autoscale)
  return(list(Null_model = nullM, BestRefit = fit))
}