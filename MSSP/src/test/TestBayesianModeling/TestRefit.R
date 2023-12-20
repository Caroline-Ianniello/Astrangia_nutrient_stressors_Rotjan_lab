source('MSSP/src/main/modeling/Refit-RStan-Lasso.R')

# 0.5291416


refit_iris <- refitRstanLasso(data = iris, formula = as.formula(paste0('Sepal.Length~',
                                                               paste(c("Sepal.Width", "Petal.Length", "Petal.Width"), collapse = '+'), 
                                                               '+(1|Species)')), 
                best_lambda = 0.5291416, location = 0, chains = 4, iter = 2000, refresh = 0)
