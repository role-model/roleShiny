#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' @import dplyr stringr ape ggtree magrittr


# function to get the date and time in a reasonable format to append to the end of files for a unique filename
file_suffix <- function() {
  Sys.time() |> 
    str_replace_all("\\:", "-") |> 
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
  
  o_rank <- o |> 
    group_by(gen) |> 
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
    geom_line(data = dat, aes_string(x = "rank", y = yvar, group = "gen"), color = "lightgrey", alpha = 0.1) +
    geom_line(data = dat, aes_string(x = "rank", y = yvar, group = "gen",  frame = "gen"), color = "#107361", alpha = 1.0) +
    labs(x = "Rank", y = y_lab, color = "Generation") +
    ylim(y = y_lims) + 
    theme_bw()  +
    theme(legend.key.size = unit(3, "mm"))
  
  p_int <- ggplotly(p) 
  
  p_build <- plotly_build(p_int)
  

  # gen_full <- dat$gen[dat$rank == min(dat$rank)] # so we can index the appropriate frame 
  # 
  # for(i in 1:length(gen_full)) {
  #   
  #   ii <- i + (-2:2) # get a range of indices centered at the current gen
  #   ii <- ii[ii %in% dat$gen] # limit to only valid indices. 
  #   ii <- ii[ii != 0] # no zeros
  #   
  #   # set x and y lims for frame `fi`
  #   p_build$x$frames[[i]]$layout <- list(xaxis = list(range = range(dat$rank[ii])), 
  #                                    yaxis = list(range = range(dat[[yvar]][ii])))
  # }

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
  
  p_fin <- p_build |>
    animation_opts(frame = 0, transition = 0, easing = "linear") |>
    animation_slider(currentvalue = list(prefix = "Gen = ", font = list(color = "black")))
  
  return(p_fin)
}

## timeseries
plotly_ts <- function(dat, yvar) {
  
  if (yvar == "all_hill") {
    y_var <- as.formula(paste0("~", "hillAbund_1"))
    y_var_2 <- as.formula(paste0("~", "hillAbund_2"))
    y_var_3 <- as.formula(paste0("~", "hillAbund_3"))
    
    pt <- dat |>
      as_tibble() |>
      plot_ly() |>
      add_lines(x = ~ gen, y = y_var, line = list(color = "#107361"), name = "Hill 1") |>
      add_lines(x = ~ gen, y = y_var_2, line = list(color = "black"), name = "Hill 2") |>
      add_lines(x = ~ gen, y = y_var_3, line = list(color = "yellow"), name = "Hill 3") |>
      layout(
        xaxis = list(title = "Time step", rangeslider = list(visible = T), gridcolor = "grey92", zerolinecolor = "grey92"),
        yaxis = list(title = "Hill number value", gridcolor = "grey92", zerolinecolor = "grey92"),
        plot_bgcolor='white'
      )
    
  } else {
    y_var <- as.formula(paste0("~", yvar))
    
    if (stringr::str_detect(yvar, "1")) {
      y_name <- "Hill 1"
    } else if (stringr::str_detect(yvar, "2")) {
      y_name <- "Hill 2"
    } else if (stringr::str_detect(yvar, "3")) {
      y_name <- "Hill 3"
    }
    
    pt <- dat |>
      as_tibble() |>
      plot_ly() |>
      add_lines(x = ~ gen, y = y_var, line = list(color = "#107361")) |>
      layout(
        xaxis = list(title = "Time step", rangeslider = list(visible = T), gridcolor = "grey92", zerolinecolor = "grey92"),
        yaxis = list(title = y_name, gridcolor = "grey92", zerolinecolor = "grey92"),
        plot_bgcolor='white'
      )
  }
  
  
  
  
  return(pt)
}

## phylogenetic tree

plotly_phylo <- function() {
  
  trees <- lapply(rep(c(10, 25, 50, 100), 3), ape::rtree)
  class(trees) <- "multiPhylo"
  
  g <- ggtree::ggtree(trees, aes(frame = .id)) + 
    ggtree::theme_tree2()
  # either remove animation labels or see "generation" label
  
  gp <- ggplotly(g) |> 
    animation_opts(250, transition = 100) |> 
    animation_slider(hide = TRUE)
  
  gp
}



