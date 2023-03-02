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


# hill calculation

## Get one hill number from a list of a variable. Original python code written by Isaac Overcast, with slight modifications (correct = TRUE implemented by CMF)
## dists are the OTU Tajima's pi
## order is the q order of the Hill number
## correct indicates if you want to correct for species richness or not. Default is TRUE
hill_calc <- function(dists, order = 1, correct = FALSE) { 
  if (order == 0) {
    return(length(dists))
  }
  if (order == 1) {
    h1 = exp(entropy::entropy(dists))
    if (correct) {
      return(h1 / length(dists))
    } else return(h1)
    
  }
  else {
    tot = sum(dists)
    proportions = dists/tot
    prop_order = proportions**order
    h2 = sum(prop_order)**(1/(1-order))
    if (correct) {
      return(h2 / length(dists))
    } else return(h2)
  }
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
gg_scatter <- function(dat, dat_2, yvar, is_abund = TRUE) {
  
  # select fewer generations to make plotting easier
  if (length(unique(dat$gen)) > 150) {
    g <- unique(dat$gen)  
    g_first <- g[1] # keep the first generation
    g_last <- g[length(g)] # keep the last generation
    g_rest <- g[-1] # sample from all except the first generation
    s_g <- sample(g_rest, 100, replace = FALSE) # sample from the generations
    s_g <- c(g_first, s_g, g_last)
    
    dat <- dat[dat$gen %in% s_g,] # filter for the sampled generations
    
  }
  
  
  
  if (is_abund) {
    y_lims <- c(min(dat$abund), max(dat$abund))
    y_lab <- "Abundance"
  } else {
    y_lims <- c(min(dat$traits), max(dat$traits))
    y_lab = "Trait"
  }
  
  p <- ggplot() +
    geom_line(data = dat, aes_string(x = "rank", y = yvar, group = "gen"), color = "lightgrey", alpha = 0.1) +
    geom_point(data = dat, aes_string(x = "rank", y = yvar, group = "gen",  frame = "gen"), color = "#107361", alpha = 1.0) +
    labs(x = "Rank", y = y_lab, color = "Generation") +
    #ylim(y = y_lims) + 
    theme_bw()  +
    theme(legend.key.size = unit(3, "mm"))
  
  p_int <- ggplotly(p) 
  
  l <- ggplot() +
    geom_line(data = dat_2, aes_string(x = "gen", y = "hillAbund_1"), color = "black", alpha = 1.0) +
    geom_point(data = dat_2, aes_string(x = "gen", y = "hillAbund_1", frame = "gen"), color = "#107361", alpha = 1.0) +
    labs(x = "Generation", y = y_lab) +
    theme_bw()  +
    theme(legend.key.size = unit(3, "mm"))
  
  l_int <- ggplotly(l)
  
  
  p_fin <- subplot(p_int, l_int) |>
    animation_slider(currentvalue = list(prefix = "Gen = ", font = list(color = "black")))
  
  return(p_fin)
}

## timeseries
gg_ts <- function(dat, yvar) {
  
  if (yvar == "all_hill") {
    y_var <- as.formula(paste0("~", "hillAbund_1"))
    y_var_2 <- as.formula(paste0("~", "hillAbund_2"))
    y_var_3 <- as.formula(paste0("~", "hillAbund_3"))
    
    pt <- dat |>
      as_tibble() |>
      plot_ly() |>
      add_lines(x = ~ gen, y = y_var, line = list(color = "#107361"), name = "q = 1") |>
      add_lines(x = ~ gen, y = y_var_2, line = list(color = "black"), name = "q = 2") |>
      add_lines(x = ~ gen, y = y_var_3, line = list(color = "yellow"), name = "q = 3") |>
      layout(
        xaxis = list(title = "Time step", rangeslider = list(visible = T), gridcolor = "grey92", zerolinecolor = "grey92"),
        yaxis = list(title = "Hill number", gridcolor = "grey92", zerolinecolor = "grey92"),
        plot_bgcolor='white',
        legend = list(x = 0.1, y = 0.95)
      )
    
  } else {
    y_var <- as.formula(paste0("~", yvar))
    
    if (stringr::str_detect(yvar, "1")) {
      y_name <- "q = 1"
    } else if (stringr::str_detect(yvar, "2")) {
      y_name <- "q = 2"
    } else if (stringr::str_detect(yvar, "3")) {
      y_name <- "q = 3"
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



