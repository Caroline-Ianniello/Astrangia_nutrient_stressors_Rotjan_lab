
# check package if exists
if(!require('caret', character.only = T)){
  install.packages('caret')
}

library(caret)

k_fold_CV <- function(data, k, random_k_fold = F){
  
  # K-Fold Cross Validation
  # ======
  # data : data to split
  # k : number of folds
  # random_k_fold: <bool> specify whether sample by random for each folds (duplicated data might exist)
  # ======
  
  nobs <- nrow(data)
  
  if (random_k_fold){ # randomized sample for each fold, replace = TRUE
    id_sample_mat <- replicate(n = k, sample(c(1:nobs), size = round(nobs/k, 0), replace = TRUE), simplify = 'list')
    k_fold_id <- list()
    for(i in 1:ncol(id_sample_mat)){
      k_fold_id[[paste0('fold', i)]] <- id_sample_mat[,i]
    }
  }
  else{ # K-fold CV that include all the observations.
    
    k_fold_id <- caret::createFolds(c(1:nobs), k = k, list = TRUE)
  }
  
  k_fold_datasets <- list()
  
  for(i in 1:k){
    k_fold_datasets[[paste0('fold',i)]] <- data[as.vector(k_fold_id[[i]]), ]
  }
  
  return(k_fold_datasets)
}

## unit test:

# tmp <- k_fold_CV(data = iris, k = 5, random_k_fold = F)
