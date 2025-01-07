expand_list_to_grid <- function(input_list) {
  do.call(expand.grid, input_list)
}

# Example usage
input_list <- list(parm1 = c(1, 2, 3), parms2 = c(1, 2))
result <- expand_list_to_grid(input_list)
print(result)
