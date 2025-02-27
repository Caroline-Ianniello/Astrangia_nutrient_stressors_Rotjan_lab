#THE FOLLOWING CODE IS COMPUTATIONALLY INTENSIVE AND WAS RUN FOR 12 hours with 1 core on the SCC

setwd("/projectnb/rotjanlab/caroline-ecotox/")
library("tidyverse")
library(ordinal)

pes_all.data <- read.csv("PES_all_06_26_24_dead_NAs.csv", header=TRUE, sep=",",stringsAsFactors = FALSE)

#Create a NEW column for nitrate with new categories
pes_all.data <- pes_all.data %>%
   mutate(NO3_category = case_when(
     NO3_mean_observed < 6  ~ "Low" , #need two equal signs
     NO3_mean_observed >= 6 ~ "Elevated" 
   )
   )
 
 pes_all.data$PES_value <- as.factor(pes_all.data$PES_value)
 pes_all.data$PES_day <- as.numeric(pes_all.data$PES_day)
 pes_all.data$NO3_category <- as.factor(pes_all.data$NO3_category)
 pes_all.data$sym_state <- as.factor(pes_all.data$sym_state)
 pes_all.data$temp <- as.factor(pes_all.data$temp)
 pes_all.data$food <- as.factor(pes_all.data$food)
 
# #################
 
 step_clmm_custom <- function(data) {
   library(ordinal)
   
   # Define the full formula terms
   full_formula <- PES_value ~ PES_day + NO3_category + sym_state + temp + food +
     NO3_category*sym_state + NO3_category*food + NO3_category*temp +
     sym_state*temp + sym_state*food + food*temp
   
   full_terms <- attr(terms(full_formula), "term.labels")
   
   # Prepare for model selection
   best_aic <- Inf
   best_model <- NULL
   model_results <- data.frame(Formula = character(), AIC = numeric(), stringsAsFactors = FALSE)
   
   # Loop over all combinations of the predictors and interactions
   for (i in seq_along(full_terms)) {
     comb <- combn(full_terms, i, simplify = FALSE)
     for (j in seq_along(comb)) {
       # Create the formula for the current combination
       current_formula <- as.formula(paste("PES_value ~", paste(comb[[j]], collapse = " + "), "+ (1|beetag_exprun)", "+ (1|exp_num)"))
       print(current_formula)
       
#       # Fit the model
       current_model <- clmm(current_formula, data = data)
       
       # Compute the AIC
       current_aic <- AIC(current_model)
       
       # Store the formula and AIC
       model_results <- rbind(model_results, data.frame(Formula = deparse(current_formula), AIC = current_aic))
       
       # Update the best model if the current one is better
       if (current_aic < best_aic) {
         best_aic <- current_aic
         best_model <- current_model
       }
     }
   }
   
   
   # Return the best model, its AIC, and all AICs
 list(best_model = best_model, best_aic = best_aic, model_results = model_results)
 }
 
# Run the stepwise selection
 result <- step_clmm_custom(pes_all.data)
 
 # Extract the best model, its AIC, and the AICs of all models
 best_model <- result$best_model
 best_aic <- result$best_aic
 model_aic_df <- result$model_results
 
 # View the dataframe of all model formulas and their AICs
 saveRDS(best_model, "best_model.RDS") #goes in the same folder because I have not adapted the directory
 write.csv(best_aic, "best_aic.csv")
 write.csv(model_aic_df, "all_aic.csv")