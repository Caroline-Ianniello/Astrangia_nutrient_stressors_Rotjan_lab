library(rstanarm)

find_best_tune <- function(MSE_array, which_MSE = 'valid'){
  
  # Find the best lambda for refitting model with entire dataset
  #=====
  # MSE_array: <array dim(l,k,2)> 
  # which_MSE: <string> 'both'/'train'/'valid', default = 'both'
  # return:
  ## which_MSE == 'both' : <vector> best lambda vector
  ## which_MSE == 'train'/'valid' : <float> best lambda value
  
  train_MSE_mat <- MSE_array[,,1]
  valid_MSE_mat <- MSE_array[,,2]
  
  lambdas_vec <- as.numeric(dimnames(MSE_array)[[1]])
  
  # calculate mean MSE for each "lambda"
  train_mean_MSE <- apply(train_MSE_mat, 1, mean, simplify = TRUE)
  valid_mean_MSE <- apply(valid_MSE_mat, 1, mean, simplify = TRUE)
  
  # extract best lambda
  best_train_lambda <- lambdas_vec[which.min(train_mean_MSE)]
  best_valid_lambda <- lambdas_vec[which.min(valid_mean_MSE)]
  
  if (which_MSE == 'both'){
    best_lambdas <- c(best_train_lambda, best_valid_lambda)
    names(best_lambdas) <- c('train', 'valid')
    return(best_lambdas)
  }
  else if(which_MSE == 'train'){
    return(best_train_lambda)
  }
  else{ # which_MSE == 'valid'
    return(best_valid_lambda)
  }
  
}


record_lambda <- function(file, model_response, pollution_type, MSE_array){
  best_lambda <- find_best_tune(MSE_array = MSE_array, which_MSE = 'both')

  file_conn <- file(file, "w")

  writeLines(paste0('# Mixed Effect Bayesian Model :\n\n'), file_conn)
  
  writeLines(paste0('## Pollution Type: ', pollution_type), file_conn)
  
  writeLines(paste0('## Response Variable: ', model_response), file_conn)
  
  writeLines("### Model Summary\n\n```\n", file_conn)
  capture.output(print(MSE_array), file = file_conn)
  writeLines("```\n\n", file_conn)
  
  writeLines(paste0("### Best Lambda\n\n",
                    "* Lambda(valid): ", best_lambda[2], "\n\n",
                    "* Lambda(train): ", best_lambda[1], "\n\n"), file_conn)

  close(file_conn)
  
}


# 
# #performance_metrics <- data.frame(lambda = numeric(), sse = numeric())
# 
# 
# calculate_performance_metrics <- function(model_fit_data, data) {
#   performance_metrics <- data.frame(lambda = numeric(), sse = numeric(), fold = integer())
#   
#   for (i in 1:length(model_fit_data)) { # not specifying the numbers of k
#     fold_data <- model_fit_data[[paste0("fold", i)]]
#     
#     for (j in 1:length(fold_data)) {
#       lambda_value <- fold_data[[j]]$lambda
#       model_fit <- fold_data[[j]]$fit
#       
#       predictions <- posterior_predict(model_fit, newdata = data)
#       mean_predictions <- colMeans(predictions)
#       actual_values <- data$pam_percent_change
#       
#       # SSE
#       sse <- sum((mean_predictions - actual_values)^2)
#       
#       performance_metrics <- rbind(performance_metrics, data.frame(lambda = lambda_value, sse = sse, fold = i))
#     }
#   }
#   
#   return(performance_metrics)
# }
# 
# 
# #performance_metrics <- calculate_performance_metrics(nitrate_percent_change_fit, nitrate)
# 
# 
# 
# 
# find_best_lambda <- function(performance_metrics) {
#   best_row <- performance_metrics[which.min(performance_metrics$sse), ]
#   
# 
#   best_lambda <- best_row$lambda
#   best_fold <- best_row$fold
#   
#   return(list(lambda = best_lambda, fold = best_fold))
# }
# 
# #find_best_lambda(performance_metrics)
# 
# 
# output_model_details <- function(model_fit, best_lambda) {
# 
#   for (i in 1:5) {
#     fold_data <- model_fit[[paste0("fold", i)]]
#     
#     for (j in 1:length(fold_data)) {
#       if (fold_data[[j]]$lambda == best_lambda) {
#       
#         selected_model <- fold_data[[j]]$fit
#         
#         
#         print(summary(selected_model))
#         
#         
#         coefficients <- coef(selected_model)
#         print(coefficients)
#         
#         return(list(summary = summary(selected_model), coefficients = coefficients))
#       }
#     }
#   }
#   
# 
#   print("No model found with the specified lambda.")
# }
# 
# # best_lambda <- find_best_lambda(performance_metrics)[[1]]
# # best_lambda
# 
# # model_details <- output_model_details(nitrate_percent_change_fit, best_lambda)
# # model_details
# 
# save_to_markdown <- function(model_fit, performance_metrics, file_path, file_name) {
#   
#   markdown_path <- paste0(file_path, "/", file_name, ".md")
#   
#   
#   best_lambda <- find_best_lambda(performance_metrics)
#   
#   
#   model_details <- output_model_details(model_fit, best_lambda$lambda)
#   
#   
#   file_conn <- file(markdown_path, "w")
#   
#   
#   writeLines(paste0("# Best Lambda\n\n", 
#                     "* Lambda: ", best_lambda$lambda, "\n", 
#                     "* Fold: ", best_lambda$fold, "\n\n"), file_conn)
#   
#   
#   writeLines("# Model Summary\n\n```\n", file_conn)
#   capture.output(print(model_details$summary), file = file_conn)
#   writeLines("```\n\n", file_conn)
#   
#   writeLines("# Model Coefficients\n\n```\n", file_conn)
#   capture.output(print(model_details$coefficients), file = file_conn)
#   writeLines("```\n\n", file_conn)
#   
#   
#   close(file_conn)
# }
# 
# 
# # file_path <- "D:/Project/Astrangia_nutrient_stressors_Rotjan_lab/MSSP/doc" 
# # file_name <- "Best_percent_lambda"           
# # save_to_markdown(nitrate_percent_change_fit, performance_metrics, file_path, file_name)
