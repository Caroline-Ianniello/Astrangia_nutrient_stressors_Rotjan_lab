library(rstanarm)
library(tidyverse)
# setwd("/Users/chentahung/Desktop/MSSP/MA675-StatisticsPracticum-1/Lab/ConsultingProjects/Urban-pollution-effect-Corals")
source('MSSP/src/main/modeling/Rstan-MixEff-Lasso.R')

# Documentation -----------------------------------------------------------


# rstan_mixEff_lasso
  # Mixed Effect Lasso Bayesian Regression
  # ===
  # data : data
  # formula : formula of the regression model
  # chain: How many chains for the stan program to conduct the HMC sampler (by default)
  # iter: number of iteration in each chain
  # refresh: set to 0 to cancel the output in console.
  # ===

# customizedRandomizedSearchCV  
  # Randomized Search K-Fold Validation Applying Customized K-Fold CV
  # ===
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh)
  # location: <int/float> mean of the laplace prior
  # lambda_dist: <callable distribution function> distribution function that lambda is going to sample from
  # ... : named parameters of the lambda_dist:
  # # e.g. : lambda_dist = rnorm, ... = (n = 1 , mean = 0, sd = 1)
  # ===
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # ===
  #          | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lamba_1  |       |       |       |       |
  # lamba_2  |       |       |       |       |
  # lamba_3  |       |       |       |       |
  # lamba_4  |       |       |       |       |
  # ...      |       |       |       |       |
  # lambda_p |       |       |       |       |

#customizedGridSearchCV
  # Grid Search K-Fold Validation Applying Customized K-Fold CV
  # ===
  # data : <class = data.frame> data to fit model
  # formula: <object = formula> formula object to pass to the fit model function
  # fold_number: <int> number k for k-fold CV.
  # stratified_target: <string> column name that is the stratified target for k-fold cv.
  # MCMC_parms: <list> list for controlling MCMC sampling method(chains, iter, refresh)
  # params_vec: Since we are only tuning the parameter "lambda" of laplace distribution, simplifying the program by giving a vector.
  # ===
  # Return: <list> MSE_array
  # illustration of matrix for first two dimensions
  # ===
  #           | fold1 | fold2 | fold3 | fold4 | fold5
  # ------------------------------------------------
  # lambda_1  |       |       |       |       |
  # lambda_2  |       |       |       |       |
  # lambda_3  |       |       |       |       |
  # lambda_4  |       |       |       |       |
  # ...       |       |       |       |       |
  # lambda_p  |       |       |       |       |


# load data ---------------------------------------------------------------

resp_model <- read_csv('MSSP/data/Respiration_all_combinations_columns.csv')

resp_model$temp <- factor(resp_model$temp, levels = c(20, 30))
resp_model$e_coli <- factor(resp_model$e_coli)

nitrate <- resp_model[resp_model$pollution == 'Nitrate',]
ammonium <- resp_model[resp_model$pollution == 'Ammonium',]

# Customized CV -----------------------------------------------------------

nitrate_resp_MSE_arr <- customizedRandomizedSearchCV(data = nitrate, 
                                  formula = as.formula('resp_rate ~ e_coli + dose_level + e_coli:dose_level + (1|col_num)'),
                                  fold_number = 5, stratified_target = 'col_num',
                                  MCMC_parms = list(chains = 3, iter = 3000, refresh = 0),
                                  randomseed = 2023,
                                  lambda_dist = rexp, n = 5, rate = 0.8)

source('MSSP/src/main/Visualization/MSE_violin_plot.R')
MSE_violin_plot(nitrate_resp_MSE_arr, which_MSE = 'valid', title = 'Ammonium - Respiration - MSE - Valid ')

# Refit -------------------------------------------------------------------

source('MSSP/src/main/model-evaluation/ModelSelect.r')
source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')

nitrate_resp_best_lambda <- find_best_tune(nitrate_resp_MSE_arr)
print(nitrate_resp_best_lambda) 


# Bayesian ----------------------------------------------------------------


Nitrate_Resp_lasso <- refitRstanLasso(data = nitrate,
                                           formula = as.formula('resp_rate ~ e_coli + dose_level + e_coli:dose_level + (1|col_num)'),
                                           best_lambda = nitrate_resp_best_lambda,
                                           iter = 4000)

summary(Nitrate_Resp_lasso$BestRefit)
fixef(Nitrate_Resp_lasso$BestRefit)


source('MSSP/src/main/Visualization/Coef-Plot.R')
plot_mixeff_coef(Nitrate_Resp_lasso$BestRefit, title = 'Nitrate Respiration')

ranef(Nitrate_Resp_lasso$BestRefit)$col_num
# Frequentist -------------------------------------------------------------


library(sjPlot)
Nitrate_Resp <- lme4::lmer(data = nitrate,
                           formula = resp_rate ~ e_coli + dose_level + e_coli:dose_level + (1|col_num))

summary(Nitrate_Resp)

df_lme4 <- data.frame(est = names(fixef(Nitrate_Resp)), coef = fixef(Nitrate_Resp))
confinv_df <- as.data.frame(confint(Nitrate_Resp)) %>% mutate(est = row.names(confint(Nitrate_Resp)))
res <- df_lme4 %>% left_join(confinv_df)

ggplot(res) +
  geom_point(aes(y = est, x = coef)) +
  geom_errorbar(aes(xmin =`2.5 %`, xmax = `97.5 %`), width = .2)

fixef(Nitrate_Resp)
confint(Nitrate_Resp)






# random effect -----------------------------------------------------------

plot(x = ranef(Nitrate_Resp)$col_num[,1], y = ranef(Nitrate_Resp_lasso$BestRefit)$col_num[,1], xlab = 'Freq', ylab = 'Bayesian')
abline(a = 0, b = 1, col = 'red')




