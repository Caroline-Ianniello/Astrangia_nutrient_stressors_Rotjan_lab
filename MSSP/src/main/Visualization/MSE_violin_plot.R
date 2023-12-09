library(tidyverse)
library(reshape2)

MSE_violin_plot <- function(MSE_array, which_MSE = 'valid', title){
  # Violin Plot for MSE array
  # ===
  # which_MSE: <string> 'both' / 'train' / 'valid'
  # title: <string> plot title
  # ===
  # Return: void
  
  if (which_MSE == 'valid'){
    MSE <- MSE_array[,,'valid']
    MSE_df <- as.data.frame(MSE) %>% mutate(lambda = rownames(MSE))
    melt_MSE_df <- melt(MSE_df, id.vars = 'lambda', measure.vars = paste0('fold', c(1:5)))
    
    plot <- ggplot(as.data.frame(melt_MSE_df)) +
      geom_violin(aes(x = lambda, y = value, color = lambda), linewidth = 2) +
      ggtitle(title) +
      theme_bw() +
      theme(legend.position = "none") 
  }
  else if(which_MSE == 'train'){ 
    MSE <- MSE_array[,,'train']
    MSE_df <- as.data.frame(MSE) %>% mutate(lambda = rownames(MSE))
    melt_MSE_df <- melt(MSE_df, id.vars = 'lambda', measure.vars = paste0('fold', c(1:5)))
    
    plot <- ggplot(as.data.frame(melt_MSE_df)) +
      geom_violin(aes(x = lambda, y = value, color = lambda), linewidth = 2) +
      ggtitle(title) +
      theme_bw() +
      theme(legend.position = "none")
  }
  else{
    MSE_t <- MSE_array[,,'train']
    MSE_t_df <- as.data.frame(MSE_t) %>% mutate(lambda = rownames(MSE_t), type = 'train')
    
    MSE_v <- MSE_array[,,'valid']
    MSE_v_df <- as.data.frame(MSE_v) %>% mutate(lambda = rownames(MSE_v), type = 'valid')
    
    MSE_df <- rbind(MSE_t_df, MSE_v_df)
    
    melt_MSE_df <- melt(MSE_df, id.vars = c('lambda', 'type'), measure.vars = paste0('fold', c(1:5)))
    plot <- ggplot(as.data.frame(melt_MSE_df)) +
      geom_violin(aes(x = lambda, y = value, color = lambda), size = 2) +
      ggtitle(title) +
      facet_wrap(vars(type), scales = 'free_y') +
      theme_bw() +
      theme(legend.position = "none") 
    
  }
  
  print(plot)
}
