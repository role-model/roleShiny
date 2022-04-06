#' rolePlots UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session,name1,name2,check1,check2,name,func,type,checkBox,allSims Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import plotly
#' 
#' 
library(plotly)
library(stringr)
library(purrr)
library(tidyr)

mod_rolePlots_ui <- function(id, name1, name2, check1, check2){
  ns <- NS(id)
  tagList(
    fluidRow(
      
      conditionalPanel(check1, class = "cond-panel", ns = ns,
                       column(5, plotlyOutput(ns(name1)))
      ),
      
      conditionalPanel(check2, class = "cond-panel", ns = ns,
                       column(7, plotlyOutput(ns(name2)))
      )
    )
  )
}
    
#' rolePlots Server Functions
#'
#' @noRd 
mod_rolePlots_server <- function(id, name, func, type, checkBox, sims_out, allSims){
  

  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # nest these if() statements in an if() statement that checks if allSims() is of a certain size (or class. Maybe I can make the empty allSims its own class to clear us of having to worry about unusable data sizes)
    observe({
      req(allSims())
      
      # abundance distributions 
      abundances <- reactive({
        c <- allSims() %>% 
          # get abundance distributions
          abund() %>% 
          # get the `com` object, which contains the 
          pluck("com_t") 
        
        # for time series plots later 
        names(c) <- 1:length(c)
        
        return(c)
      })
      
      # trait distributions
      traits <- reactive({
        t <- allSims() %>% 
          pluck("com_t")
        
        names(t) <- 1:length(t)
        
        return(t)
      })
        
        
      
      if (stringr::str_detect(name, "abundDist")) {
        
        # sampling timesteps so the rank plot doesn't take forever to render and isn't too dense
        n_ts <- length(allSims()$com_t)
        if (n_ts > 100) {
          ts_sample <- sample.int(n_ts - 1, 100) %>% 
            # make sure to include the most recent time step
            append(n_ts)
          
        } else ts_sample <- 1:length(n_ts)
        
        
        fig <-  reactive({
          # take a sample of the communities
          abund_sample <- abundances()[ts_sample]
          
          c_df <- abund_sample %>% 
            bind_rows(.id = "timestep") %>% 
            group_by(timestep) %>% 
            arrange(desc(ab), .by_group = TRUE) %>% 
            mutate(rank = row_number()) %>% 
            ungroup() %>% 
            mutate(timestep = as.integer(timestep)) %>% 
            arrange(desc(timestep))
          
          p <- c_df %>% 
            ggplot(aes(x = rank, y = ab, group = timestep, color = timestep)) +
            geom_line(alpha = 0.5) +
            scale_color_viridis_c() +
            theme_minimal()
          
          p_int <- ggplotly(p)
          
          return(p_int)
          
        })
      
        output[[name]] <- renderPlotly({
          fig()
        })
        
      } else if (stringr::str_detect(name, "abundTime")) {
        
        # extract the communities from the time series
        fig <-  reactive({
        sim_shannon <- abundances() %>% 
          map_df(~entropy::entropy(.$ab)) %>% 
          pivot_longer(cols = everything(), 
                       names_to = "time", 
                       values_to = "shannon") %>% 
          mutate(time = as.integer(time)) %>% 
          arrange(desc(time))
           
          
            sim_shannon %>%
              plot_ly(x = ~time, y = ~shannon) %>%
              add_lines() %>%
              layout(xaxis = list(title = "Time step"), yaxis = list(title = "Shannon entropy"))
        }) 
        
        output[[name]] <- renderPlotly({
          fig()
        })
      } else if (stringr::str_detect(name, "traitDist")) {
        
        # sampling timesteps so the rank plot doesn't take forever to render and isn't too dense
        n_ts <- length(allSims()$com_t)
        if (n_ts > 100) {
          ts_sample <- sample.int(n_ts - 1, 100) %>% 
            # make sure to include the most recent time step
            append(n_ts)
        } else ts_sample <- 1:length(n_ts)
        
        fig <- reactive({
          # take a sample of the communities
          traits_sample <- traits()[ts_sample]
          
          t_df <- traits_sample %>% 
            bind_rows(.id = "timestep") %>% 
            mutate(timestep = as.integer(timestep)) %>% 
            arrange(desc(timestep))
          
          p <- t_df %>% 
            ggplot(aes(x = trait, group = timestep, color = timestep)) +
            geom_density() +
            scale_color_viridis_c() +
            theme_minimal()
          
          p_int <- ggplotly(p)
          
          return(p_int)
        })
        
        output[[name]] <- renderPlotly({
          fig()
        })
        
      } else if (stringr::str_detect(name, "traitTime")) {
        
        fig <- reactive({
          sim_traits <- traits() %>% 
            map_df(~mean(.$trait)) %>% 
            pivot_longer(cols = everything(), 
                         names_to = "time", 
                         values_to = "mean_trait") %>% 
            mutate(time = as.integer(time)) %>% 
            arrange(desc(time))
          
          sim_traits %>%
            plot_ly(x = ~time, y = ~mean_trait) %>%
            add_lines() %>%
            layout(xaxis = list(title = "Time step"), yaxis = list(title = "Mean trait"))
        })
        
        output[[name]] <- renderPlotly({
          fig()
        })
        
      }
    
    }) %>% 
      bindEvent(input$playBtn)
  }
    
    
    

  )
}
    
## To be copied in the UI
# mod_rolePlots_ui("rolePlots_ui_1")
    
## To be copied in the server
# mod_rolePlots_server("rolePlots_ui_1")
