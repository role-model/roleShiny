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
                       column(6, plotlyOutput(ns(name1)))
      ),
      
      conditionalPanel(check2, class = "cond-panel", ns = ns,
                       column(6, plotlyOutput(ns(name2)))
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
        get_abund(allSims())
      })
      
      # trait distributions
      traits <- reactive({
        get_traits(allSims())
      })
        
        
      
      if (stringr::str_detect(name, "abundDist")) {
        
        
        fig <-  reactive({
          
          c_df <- sample_ts(abundances(), n_ts = input$nout, is_abund = TRUE)
          
          pool <- get_meta_abund(allSims())
          
          p <- ggplot() +
            geom_line(data = c_df, aes(x = rank, y = ab, group = timestep, color = timestep), alpha = 0.3) +
            geom_line(data = c_df, aes(x = rank, y = ab, group = timestep, color = timestep, frame = timestep)) +
            scale_color_viridis_c() +
            geom_line(data = pool, aes(x = rank, y = ab), color = "black", linetype = "dashed") +
            labs(x = "Rank", y = "Abundance", color = "Time step") +
            theme_minimal() +
            theme(legend.key.size = unit(0.5, 'cm'))
          
          p_int <- ggplotly(p) %>% 
            animation_opts(250, transition = 100)
            
          
          return(p_int)
          
        })
      
        output[[name]] <- renderPlotly({
          fig()
        })
        
      } else if (stringr::str_detect(name, "abundTime")) {
        
        
        fig <-  reactive({
           
          abund_sumstats <- calc_abund_sumstats(abundances())
          
           abund_sumstats %>%
              plot_ly(x = ~time, y = ~shannon) %>%
              add_lines() %>%
              layout(xaxis = list(title = "Time step"), yaxis = list(title = "Shannon entropy"))
        }) 
        
        output[[name]] <- renderPlotly({
          fig()
        })
      } else if (stringr::str_detect(name, "traitDist")) {
        
        fig <- reactive({
          
          t_df <- sample_ts(traits(), n_ts = input$nout, is_abund = FALSE)
          
          pool <- get_meta_traits(allSims())
          
          p <- ggplot() +
            geom_line(data = t_df, aes(x = rank, y = trait, group = timestep, color = timestep), alpha = 0.3) +
            geom_line(data = t_df, aes(x = rank, y = trait, group = timestep, color = timestep, frame = timestep)) +
            scale_color_viridis_c() +
            geom_line(data = pool, aes(x = rank, y = trait), color = "black", linetype = "dashed") +
            labs(x = "Rank", y = "Trait", color = "Time step") +
            theme_minimal() +
            theme(legend.key.size = unit(0.5, 'cm'))
          
          p_int <- ggplotly(p) %>% 
            animation_opts(250, transition = 100) 
          
          return(p_int)
        })
        
        output[[name]] <- renderPlotly({
          fig()
        })
        
      } else if (stringr::str_detect(name, "traitTime")) {
        
        fig <- reactive({
          
          trait_sumstats <- calc_trait_sumstats(traits())
          
          trait_sumstats %>%
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
