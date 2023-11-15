
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
      k_fold_id <- caret::createFolds(data[stratified_target], k = k, list = TRUE)  
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

# tmp <- k_fold_CV(data = iris, k = 5, random_k_fold = F)
