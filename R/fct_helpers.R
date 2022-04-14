#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 


hill_calc <- hill_calc <- function(dists, order = 1, correct = TRUE) { 
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

### simulated data processing functions

# get abundance distributions
get_abund <- function(allSims) {
  c <- allSims %>% 
    # get abundance distributions
    abund() %>% 
    # get the `com` object, which contains the 
    pluck("com_t") 
  
  # for time series plots later 
  names(c) <- 1:length(c)
  
  return(c)
}

# get trait distributions
get_traits <- function(allSims) {
  t <- allSims %>% 
    pluck("com_t")
  
  names(t) <- 1:length(t)
  
  return(t)
}

# sample abundance and trait distributions for plotting and format them
# comm_list is the output from get_abund or get_traits
# n_ts is the number of timesteps to sample. This comes from the input$nout parameter
# is_abund asks if the list contains abundances or not, for determining the variable to sort by
sample_ts <- function(comm_list, n_ts, is_abund = TRUE) {
  
  # evenly distribute samples across the time series
  ts_sample <- round(seq(from = 2, to = length(comm_list), length.out = n_ts))
  
  # index for the samples
  comm_sample <- comm_list[ts_sample]
  
  # if else for the variable to sort by
  if (is_abund) {
    sort_var <- "ab"
  } else sort_var <- "trait"
  
  c <- comm_sample %>% 
    # take the list of timesteps and combine into a single dataframe
    bind_rows(.id = "timestep") %>% 
    # group by timestep and sort from most abundant/largest trait to least abundant/lowest trait
    group_by(timestep) %>% 
    arrange(desc(!!sym(sort_var)), .by_group = TRUE) %>% 
    # the rank is now the row number, since they're sorted
    mutate(rank = row_number()) %>% 
    ungroup() %>% 
    # convert timestep to an integer (is a character at first) and sort the timesteps
    mutate(timestep = as.integer(timestep)) %>% 
    arrange(desc(timestep))
  
  return(c)
}


# calculate abundance summary stats
# abund is the output of get_abund

calc_abund_sumstats <- function(abund) {
  
  sim_stats <- abund %>% 
    map_df(~entropy::entropy(.$ab)) %>% 
    pivot_longer(cols = everything(), 
                 names_to = "time", 
                 values_to = "shannon") %>% 
    mutate(time = as.integer(time)) %>% 
    arrange(desc(time))
  
  return(sim_stats)
}

# calculate trait sumstats
# tr is the output from get_traits
calc_trait_sumstats <- function(tr) {
  
  sim_stats <- tr %>% 
    map_df(~mean(.$trait)) %>% 
    pivot_longer(cols = everything(), 
                 names_to = "time", 
                 values_to = "mean_trait") %>% 
    mutate(time = as.integer(time)) %>% 
    arrange(desc(time))
  
  return(sim_stats)
}



