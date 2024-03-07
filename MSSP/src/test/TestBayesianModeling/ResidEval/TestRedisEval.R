
source('MSSP/src/main/model-evaluation/ResidualEvaluation.R')


evaluate_residuals(model = refit_iris$BestRefit)

plot_residuals(refit_iris$BestRefit)

plot_leverage(refit_iris$BestRefit)

plot_qq(refit_iris$BestRefit)

plot_binned_residuals(refit_iris$BestRefit)
