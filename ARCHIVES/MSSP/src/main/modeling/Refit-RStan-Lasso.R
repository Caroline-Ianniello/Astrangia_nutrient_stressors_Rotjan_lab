
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



refitRstanLasso <- function(data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0, adapt_delta = NULL, QR = FALSE, sparse = FALSE){
  
  # create null model formula:
  formula_parts <- strsplit(as.character(formula), "~")[[2]]
  null_formula <- as.formula(paste0(formula_parts, "~ 1"))
  
  # fit null model
  nullM <-  stan_glm(null_formula, data = data, chains = 2, iter = 1000, refresh = 0)
  
  fit <- rstan_mixEff_lasso(data, formula, location = 0, lambda = best_lambda, 
                            chains = chains, iter = iter, refresh = refresh, 
                            adapt_delta = adapt_delta, QR = QR, sparse = sparse)
  return(list(Null_model = nullM, BestRefit = fit))
}