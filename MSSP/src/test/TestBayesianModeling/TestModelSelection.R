source('MSSP/src/main/model-evaluation/ModelSelect.r')

performance_iris <- calculate_performance_metrics(iris_rstan, iris)
find_best_lambda(performance_iris)
