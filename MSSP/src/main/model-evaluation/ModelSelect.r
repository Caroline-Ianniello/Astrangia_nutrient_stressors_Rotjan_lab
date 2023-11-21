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


#performance_metrics <- calculate_performance_metrics(nitrate_percent_change_fit, nitrate)




find_best_lambda <- function(performance_metrics) {
  best_row <- performance_metrics[which.min(performance_metrics$sse), ]
  

  best_lambda <- best_row$lambda
  best_fold <- best_row$fold
  
  return(list(lambda = best_lambda, fold = best_fold))
}

#find_best_lambda(performance_metrics)


output_model_details <- function(model_fit, best_lambda) {

  for (i in 1:5) {
    fold_data <- model_fit[[paste0("fold", i)]]
    
    for (j in 1:length(fold_data)) {
      if (fold_data[[j]]$lambda == best_lambda) {
      
        selected_model <- fold_data[[j]]$fit
        
        
        print(summary(selected_model))
        
        
        coefficients <- coef(selected_model)
        print(coefficients)
        
        return(list(summary = summary(selected_model), coefficients = coefficients))
      }
    }
  }
  

  print("No model found with the specified lambda.")
}

# best_lambda <- find_best_lambda(performance_metrics)[[1]]
# best_lambda

# model_details <- output_model_details(nitrate_percent_change_fit, best_lambda)
# model_details

save_to_markdown <- function(model_fit, performance_metrics, file_path, file_name) {
  
  markdown_path <- paste0(file_path, "/", file_name, ".md")
  
  
  best_lambda <- find_best_lambda(performance_metrics)
  
  
  model_details <- output_model_details(model_fit, best_lambda$lambda)
  
  
  file_conn <- file(markdown_path, "w")
  
  
  writeLines(paste0("# Best Lambda\n\n", 
                    "* Lambda: ", best_lambda$lambda, "\n", 
                    "* Fold: ", best_lambda$fold, "\n\n"), file_conn)
  
  
  writeLines("# Model Summary\n\n```\n", file_conn)
  capture.output(print(model_details$summary), file = file_conn)
  writeLines("```\n\n", file_conn)
  
  writeLines("# Model Coefficients\n\n```\n", file_conn)
  capture.output(print(model_details$coefficients), file = file_conn)
  writeLines("```\n\n", file_conn)
  
  
  close(file_conn)
}


# file_path <- "D:/Project/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/doc" 
# file_name <- "Best_percent_lambda"           
# save_to_markdown(nitrate_percent_change_fit, performance_metrics, file_path, file_name)
