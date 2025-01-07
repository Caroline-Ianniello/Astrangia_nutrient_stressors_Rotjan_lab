library(data.table)

concatenate_columns <- function(df, cols) {
  apply(df[, .SD, .SDcols = cols], 1, paste, collapse = "-x-")
}

create_columns <- function(df, combinations){
  for (i in 1:ncol(combinations)) {
    combo <- combinations[, i]
    new_col_name <- paste(combo, collapse = "_x_")
    
    df[,(new_col_name) := concatenate_columns(df, combo)]
  }
}
