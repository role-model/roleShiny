#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' @import dplyr stringr ape ggtree


# function to get the date and time in a reasonable format to append to the end of files for a unique filename
file_suffix <- function() {
  Sys.time() %>% 
    str_replace_all("\\:", "-") %>% 
    str_replace_all(" ", "_")
}

# process raw abundances for plotting
# ss = sumstats, output from getSumStats
# raw_string = the raw data you want to format. For now, choices are "



tidy_raw_rank <- function(ss, raw_string) {
  o <- lapply(1:nrow(ss), function(i) {
    x <- ss[[raw_string]][[i]]
    x <- sort(x[x > 0], decreasing = TRUE)
    
    g <- rep(ss$gen[i], length(x))
    
    return(cbind(g, x))
  })
  
  o <- as.data.frame(do.call(rbind, o))
  
  colnames(o) <- c('gen', raw_string)
  
  o_rank <- o %>% 
    group_by(gen) %>% 
    mutate(rank = row_number())
  
  return(o_rank)
}


# plotting functions to make plotting easier
## scatterplot
gg_scatter <- function(dat, yvar, is_abund = TRUE) {
  
  if (is_abund) {
    y_lims <- c(min(dat$abund), max(dat$abund))
    y_lab <- "Abundance"
  } else {
    y_lims <- c(min(dat$traits), max(dat$traits))
    y_lab = "Trait"
  }
  
  p <- ggplot() +
    #geom_line(data = dat, aes_string(x = "rank", y = yvar, group = "gen", color = "gen"), alpha = 0.1) +
    geom_line(data = dat, aes_string(x = "rank", y = yvar, group = "gen",  frame = "gen"), color = "#107361", alpha = 1.0) +
    labs(x = "Rank", y = y_lab, color = "Generation") +
    ylim(y = y_lims) + 
    theme_bw()  +
    theme(legend.key.size = unit(3, "mm"))
  
  p_int <- ggplotly(p) 
  
  p_build <- plotly_build(p_int)
  
  # unique generations
  # unigen <- sort(unique(dat$gen))
  # 
  # for(i in 1:length(p_build$x$frames)) {
  #   currGen <- unigen[i]
  #   ii <- currGen + (-2:2)
  #   
  #   ii <- ii[ii %in% unigen] # limit to only valid indices
  #   ii <- which(dat$gen %in% ii)
  # 
  #   
  #   # set x and y lims for frame `i`
  #   p_build$x$frames[[i]]$layout <- list(xaxis = list(range = c(1, max(dat$rank[ii]))), 
  #                                        yaxis = list(range = c(1, max(dat[[yvar]][ii]))))
  # }
  
  p_int <- p_build %>%
    animation_opts(250, transition = 10) %>%
    animation_slider(currentvalue = list(prefix = "Gen = ", font = list(color = "black")))
  
  return(p_int)
}

## timeseries
plotly_ts <- function(dat, yvar) {
  
  y_var <- as.formula(paste0("~", yvar))
  
  pt <- dat %>%
    as_tibble() %>%
    plot_ly(x = ~ gen, y = y_var, line = list(color = "#107361")) %>%
    add_lines() %>%
    layout(
      xaxis = list(title = "Time step", rangeslider = list(visible = T), gridcolor = '#e5ecf6', zerolinecolor = '#e5ecf6'),
      yaxis = list(title = yvar, gridcolor = '#e5ecf6', zerolinecolor = '#e5ecf6'),
      plot_bgcolor='#303030'
    )
  return(pt)
}

## phylogenetic tree

plotly_phylo <- function() {
  
  trees <- lapply(rep(c(10, 25, 50, 100), 3), ape::rtree)
  class(trees) <- "multiPhylo"
  
  g <- ggtree::ggtree(trees, aes(frame = .id)) + 
    ggtree::theme_tree2()
  # either remove animation labels or see "generation" label
  
  gp <- ggplotly(g) %>% 
    animation_opts(250, transition = 100) %>% 
    animation_slider(hide = TRUE)
  
  gp
}



