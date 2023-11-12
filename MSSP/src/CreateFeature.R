
# library -----------------------------------------------------------------

pacman::p_load(data.table, rstanarm)


# data manipulation -------------------------------------------------------


pam <- read_csv('MSSP/data/pam_s.csv')
pam <- as.data.table(pam)

twoComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 2)
threeComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 3)
fourComb <- combn(c('dose_level', 'temp', 'feed', 'symbiont'), 4)

concatenate_columns <- function(df, cols) {
  apply(pam[, .SD, .SDcols = cols], 1, paste, collapse = "-x-")
}

create_columns <- function(df, combinations){
  for (i in 1:ncol(combinations)) {
    combo <- combinations[, i]
    new_col_name <- paste(combo, collapse = "_x_")
    
    df[,(new_col_name) := concatenate_columns(df, combo)]
  }
}

create_columns(pam, twoComb)
create_columns(pam, threeComb)
create_columns(pam, fourComb)

nitrate <- pam[pollution == 'Nitrate',]
ammonium <- pam[pollution == 'Ammonium']

write_csv(pam, 'MSSP/data/PAM_all_combinations_columns.csv')
