source('MSSP/src/modeling/Rstan-Lasso.R')

# rstan_mixEff_lasso
  # Mixed Effect Lasso Bayesian Regression
  # ======
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # ======


refitRstanLasso <- function(data, formula, best_lambda, location = 0, chains = 4, iter = 2000, refresh = 0){
  
  # create null model formula:
  formula_parts <- strsplit(as.character(formula), "~")[[1]]
  null_formula <- as.formula(paste0(response_var, "~ 1"))
  
  # fit null model
  nullM <-  stan_glm(null_formula, data = data)
  
  fit <- rstan_mixEff_lasso(data, formula, location = 0, lambda = best_lambda, chains = chains, iter = iter, refresh = refresh)
  return(list(Null_model = nullM, BestRefit = fit))
}