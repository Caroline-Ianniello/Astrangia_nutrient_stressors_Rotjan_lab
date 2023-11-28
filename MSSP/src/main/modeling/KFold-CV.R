
# check package if exists
if(!require('caret', character.only = T)){
  install.packages('caret')
}

library(caret)

k_fold_CV <- function(data, stratified_target = NULL, k, random_k_fold = F, rand_select_nobs = NULL){
  
  # K-Fold Cross Validation
  # ======
  # data : data to split
  # stratified_target: <string> column_name
  # k : number of folds
  # random_k_fold: <bool> specify whether sample by random for each folds (duplicated data might exist)
  # rand_select_nobs: <float, int> number or proportion to sample in each fold.
  # ======
  
  nobs <- nrow(data)
  
  if (random_k_fold){ # randomized sample for each fold, replace = TRUE
    if(is.null(rand_select_nobs)){ # by default
      id_sample_mat <- replicate(n = k, sample(c(1:nobs), size = round(nobs/k, 0), replace = TRUE), simplify = 'list')  
    }
    else{
      if(rand_select_nobs > 0 & rand_select_nobs <= 1){
        # select by proportion
        id_sample_mat <- replicate(n = k, sample(c(1:nobs), size = round(nobs*rand_select_nobs, 0), replace = TRUE), simplify = 'list')  
      }
      else{
        # select by number
        id_sample_mat <- replicate(n = k, sample(c(1:nobs), size = round(rand_select_nobs, 0), replace = TRUE), simplify = 'list')  
      }
    }
    k_fold_id <- list()
    for(i in 1:ncol(id_sample_mat)){
      k_fold_id[[paste0('fold', i)]] <- id_sample_mat[,i]
    }
  }
  else{ # K-fold CV that include all the observations.
    if(!is.null(stratified_target)){ # target to stratified exists
      k_fold_id <- caret::createFolds(data[[stratified_target]], k = k, list = TRUE)  
    }
    else{
      k_fold_id <- caret::createFolds(c(1:nobs), k = k, list = TRUE)
    }
  }
  
  k_fold_datasets <- list()
  
  for(i in 1:k){
    k_fold_datasets[[paste0('fold',i)]] <- data[as.vector(k_fold_id[[i]]), ]
  }
  
  return(k_fold_datasets)
}

## unit test:

#tmp <- k_fold_CV(data = iris, k = 5, random_k_fold = F)




##new

k_fold_CV_stratify <- function(data, k, column_for_freq, random_k_fold = FALSE, rand_select_nobs = NULL) {
  nobs <- nrow(data)
  
  # Identify rows in the specified column that appear less than k times
  freq <- table(data[[column_for_freq]])
  less_than_k <- names(freq[freq < k])
  isolated_data <- data[data[[column_for_freq]] %in% less_than_k, ]
  remaining_data <- data[!data[[column_for_freq]] %in% less_than_k, ]
  
  # Perform K-fold CV on the remaining data
  if (random_k_fold) {
    # Randomized sampling
    id_sample_mat <- replicate(n = k, sample(c(1:nrow(remaining_data)), size = ifelse(is.null(rand_select_nobs), round(nobs/k), ifelse(rand_select_nobs > 0 & rand_select_nobs <= 1, round(nobs*rand_select_nobs), round(rand_select_nobs))), replace = TRUE), simplify = 'list')
    
    k_fold_id <- list()
    for(i in 1:ncol(id_sample_mat)){
      k_fold_id[[paste0('fold', i)]] <- id_sample_mat[,i]
    }
  } else {
    # Standard K-fold CV on remaining data
    k_fold_id <- caret::createFolds(c(1:nrow(remaining_data)), k = k, list = TRUE)
  }
  
  # Add isolated data to each training fold
  k_fold_datasets <- list()
  for (i in 1:k) {
    # Combine training indices for all folds except the current one
    training_ids <- unlist(k_fold_id[-i])
    training_data <- remaining_data[training_ids, ]
    # Add the isolated data to the training set
    training_data <- rbind(training_data, isolated_data)
    # Add training and test sets to the list for each fold
    k_fold_datasets[[paste0('fold', i)]] <- list(
      train = training_data,
      test = remaining_data[k_fold_id[[i]], ]
    )
  }
  
  return(k_fold_datasets)
}

## unit test:

#tmp1 <- k_fold_CV(data = iris,iris$Species, k = 5, random_k_fold = F)




customize_k_fold_CV <- function(data, stratified_target, k, random_k_fold = FALSE, rand_select_nobs = NULL) {
  
  # Check if stratified_target column exists
  if (!is.null(stratified_target) && !stratified_target %in% names(data)) {
    stop("stratified_target must be a column name in data")
  }
  
  # Create a list to hold the final fold datasets
  k_fold_datasets <- list()
  
  # Split data according to the stratified target with caret's createFolds function
  folds <- caret::createFolds(data[[stratified_target]], k = k, list = TRUE)
  
  # Identify strata with fewer observations than k
  strata_counts <- table(data[[stratified_target]])
  small_strata <- names(strata_counts[strata_counts < k])
  
  # Data from small strata will be included in every fold
  small_strata_data <- data[data[[stratified_target]] %in% small_strata, ]
  
  # Create k folds ensuring small strata data is included in each fold
  for (i in seq_len(k)) {
    # Data for the current fold
    fold_indices <- folds[[i]]
    fold_data <- data[fold_indices, ]
    
    # Combine the small strata data with the current fold data
    fold_data <- rbind(fold_data, small_strata_data)
    
    # Assign the combined data to the fold_datasets list
    k_fold_datasets[[i]] <- fold_data
  }
  
  return(k_fold_datasets)
}

## unit test:

#tmp2 <- customize_k_fold_CV(data = iris, stratified_target = "Species", k = 5, random_k_fold = FALSE)
#tmp2[[1]]









