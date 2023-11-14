library(rstanarm)


#performance_metrics <- data.frame(lambda = numeric(), sse = numeric())


calculate_performance_metrics <- function(model_fit_data, data) {
  performance_metrics <- data.frame(lambda = numeric(), sse = numeric(), fold = integer())
  
  for (i in 1:5) {
    fold_data <- model_fit_data[[paste0("fold", i)]]
    
    for (j in 1:length(fold_data)) {
      lambda_value <- fold_data[[j]]$lambda
      model_fit <- fold_data[[j]]$fit
      
      predictions <- posterior_predict(model_fit, newdata = data)
      mean_predictions <- colMeans(predictions)
      actual_values <- data$pam_percent_change
      
      # SSE
      sse <- sum((mean_predictions - actual_values)^2)
      
      performance_metrics <- rbind(performance_metrics, data.frame(lambda = lambda_value, sse = sse, fold = i))
    }
  }
  
  return(performance_metrics)
}


performance_metrics <- calculate_performance_metrics(nitrate_percent_change_fit, nitrate)




find_best_lambda <- function(performance_metrics) {
  best_row <- performance_metrics[which.min(performance_metrics$sse), ]
  

  best_lambda <- best_row$lambda
  best_fold <- best_row$fold
  
  return(list(lambda = best_lambda, fold = best_fold))
}

find_best_lambda(performance_metrics)

