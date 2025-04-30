#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' @import dplyr stringr ape ggtree magrittr

library(dplyr)
library(ggtree)
library(plotly)

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
library(plotly)

# Updated gg_scatter function to incorporate animated plots with plotly
gg_scatter <- function(dat, dat_2, yvar, is_abund = TRUE) {
  if (is.null(dat_2)) {
    stop("dat_2 (output from getSumStats) is required for animation.")
  }
  
  n_frames <- min(length(dat_2[[if (is_abund) "abund" else yvar]]))
  
  if (is_abund) {
    # --- Rank-abundance data prep ---
    formatted <- lapply(seq_len(n_frames), function(i) {
      a <- dat_2$abund[[i]]
      a <- sort(a[a > 0], decreasing = TRUE)
      data.frame(tt = i, r = seq_along(a), a = a)
    })
    dat_formatted <- do.call(rbind, formatted)
    
    # --- Time series data prep (hillAbund_1) ---
    frames <- lapply(seq_len(n_frames), function(i) {
      data.frame(tt = i,
                 x = seq_len(i),
                 y = dat_2$rich[1:i],
                 frame_id = i)
    })
    time_data <- do.call(rbind, frames)
    
    p_main <- plot_ly(dat_formatted, x = ~r, y = ~a, frame = ~tt,
                      type = 'scatter', mode = 'markers',
                      marker = list(color = '#107361'),
                      showlegend = FALSE) %>%
      layout(
        xaxis = list(title = "", showticklabels = TRUE, range = c(0, 20)),
        yaxis = list(title = "", showticklabels = TRUE, range = c(0, 20))
      )
    
    p_time <- plot_ly(time_data, x = ~x, y = ~y, frame = ~frame_id,
                      type = 'scatter', mode = 'lines+markers',
                      line = list(color = 'black'),
                      marker = list(color = '#107361'),
                      showlegend = FALSE) %>%
      layout(
        xaxis = list(title = "", showticklabels = TRUE, range = c(0, n_frames + 1)),
        yaxis = list(title = "", showticklabels = TRUE, range = c(0, max(time_data$y) * 1.1))
      )
  } else {
    # --- Rank-trait data prep ---
    formatted <- lapply(seq_len(n_frames), function(i) {
      vals <- dat_2[[yvar]][[i]]
      vals <- sort(vals, decreasing = TRUE)
      data.frame(tt = i, r = seq_along(vals), t = vals)
    })
    dat_formatted <- do.call(rbind, formatted)
    
    # --- Time series data prep (hillTrait_1) ---
    frames <- lapply(seq_len(n_frames), function(i) {
      data.frame(tt = i,
                 x = seq_len(i),
                 y = dat_2$hillTrait_1[1:i],
                 frame_id = i)
    })
    time_data <- do.call(rbind, frames)
    
    p_main <- plot_ly(dat_formatted, x = ~r, y = ~t, frame = ~tt,
                      type = 'scatter', mode = 'markers',
                      marker = list(color = '#107361'),
                      showlegend = FALSE) %>%
      layout(
        xaxis = list(title = "", showticklabels = TRUE, range = c(0, max(dat_formatted$r) + 1)),
        yaxis = list(title = "", showticklabels = TRUE, range = c(0, max(dat_formatted$t) * 1.1))
      )
    
    p_time <- plot_ly(time_data, x = ~x, y = ~y, frame = ~frame_id,
                      type = 'scatter', mode = 'lines+markers',
                      line = list(color = 'black'),
                      marker = list(color = '#107361'),
                      showlegend = FALSE) %>%
      layout(
        xaxis = list(title = "", showticklabels = TRUE, range = c(0, n_frames + 1)),
        yaxis = list(title = "", showticklabels = TRUE, range = c(0, max(time_data$y) * 1.1))
      )
  }
  
  # Combine plots without titles
  p_combined <- subplot(p_main, p_time, nrows = 1, shareX = FALSE, titleX = TRUE) %>%
    animation_slider(currentvalue = list(prefix = "Gen = ", font = list(color = "black"))) %>%
    animation_opts(frame = 200, redraw = TRUE)
  
  shinybusy::remove_modal_spinner()
  return(p_combined)
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



