#' rolePlots UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session,name1,name2,check1,check2,name,func,type,checkBox,allSims Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny plotly roleR ggplot2
#' @importFrom dplyr left_join
#' 

mod_rolePlots_ui <- function(id 
                             #name1, 
                             #name2, 
                             #check1, 
                             #check2
                             ){
  ns <- NS(id)
  tagList(
    tabsetPanel(
      type = "tabs",
      tabPanel("Abundances", 
               fluidRow(
                 column(width = 4, 
                        plotlyOutput(ns("abundRank"))
                        ),
               column(width = 4, 
                      plotlyOutput(ns("abundTime"))
                      )
               )
               ),
      tabPanel("Traits", 
               fluidRow(
                 column(width = 4, 
                        plotlyOutput(ns("traitRank"))
                 ),
                 column(width = 4, 
                        plotlyOutput(ns("traitTime"))
                 )
               )
      )
      )  
    )
}
    
#' rolePlots Server Functions
#'
#' @noRd 
mod_rolePlots_server <- function(id, 
                                 #name, 
                                 #func, 
                                 #type, 
                                 #checkBox, 
                                 sims_out, 
                                 allSims){
  

  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # nest these if() statements in an if() statement that checks if allSims() is of a certain size (or class. Maybe I can make the empty allSims its own class to clear us of having to worry about unusable data sizes)
    
    observe({
      
      req(allSims())
    
      sumstats <- reactive({
        ss <- getSumStats(allSims(), 
                    funs = list(abund = rawAbundance, 
                                hillAbund = hillAbund, 
                                rich = richness,
                                traits = rawTraits,
                                hillTrait = hillTrait), 
                    moreArgs = list(hillAbund = list(q = 1:3)))
        ss[,"gen"] <- allSims()@experimentMeta$generations
        
        return(ss)
      })
      
      meta <- reactive({
        slot(allSims(), "experimentMeta")
      })
      
      raw <- reactive({
        abund <- tidy_raw_rank(sumstats(), "abund")
        traits <- tidy_raw_rank(sumstats(), "traits")
        
        return(list(abund = abund, traits = traits))
      })  
      
      # if (stringr::str_detect(name, "abundDist")) {
        
        
        fig_abundRank <-  reactive({
        
          abund_rank <- raw()$abund
          
          p <- ggplot() +
            geom_line(data = abund_rank, aes(x = rank, y = abund, group = gen, color = gen, frame = gen), alpha = 0.3) +
            scale_color_viridis_c() +
            labs(x = "Rank", y = "Abundance", color = "Generation") +
            ylim(y = c(min(abund_rank$abund), max(abund_rank$abund))) + 
            theme_minimal() +
            theme(legend.key.size = unit(0.5, 'cm'))
          
          p_int <- ggplotly(p) %>% 
            animation_opts(250, transition = 100)
            
          
          return(p_int)
          
        })
      
        output$abundRank <- renderPlotly({
          fig_abundRank()
        })
        
      # } else if (stringr::str_detect(name, "abundTime")) {
        
        
        
        fig_abundTime <-  reactive({
          
           sumstats() %>%
            as_tibble() %>% 
              plot_ly(x = ~gen, y = ~hillAbund_1) %>%
              add_lines() %>%
              layout(xaxis = list(title = "Time step"), yaxis = list(title = "Hill 1"))
        }) 
        
        output$abundTime <- renderPlotly({
          fig_abundTime()
        })
     # } else if (stringr::str_detect(name, "traitDist")) {
        
        fig_traitRank <- reactive({
        
          trait_rank <- raw()$traits
          
          p <- ggplot() +
            geom_line(data = trait_rank, aes(x = rank, y = traits, group = gen, color = gen, frame = gen), alpha = 0.3) +
            scale_color_viridis_c() +
            labs(x = "Rank", y = "Trait", color = "Generation") +
            ylim(y = c(min(trait_rank$traits), max(trait_rank$traits))) + 
            theme_minimal() +
            theme(legend.key.size = unit(0.5, 'cm'))
          
          p_int <- ggplotly(p) %>% 
            animation_opts(250, transition = 100)
          
          
          return(p_int)
        })
        
        output$traitRank <- renderPlotly({
          fig_traitRank()
        })
        
       # } else if (stringr::str_detect(name, "traitTime")) {
        
        fig_traitTime <- reactive({
          
          sumstats() %>%
            as_tibble() %>% 
            plot_ly(x = ~gen, y = ~hillTrait_1) %>%
            add_lines() %>%
            layout(xaxis = list(title = "Time step"), yaxis = list(title = "Hill 1"))
        })
        
        output$traitTime <- renderPlotly({
          fig_traitTime()
        })
        
      # }
    
    }) %>% 
      bindEvent(input$playBtn)
  }
    
    
    

  )
}
    
## To be copied in the UI
# mod_rolePlots_ui("rolePlots_ui_1")
    
## To be copied in the server
# mod_rolePlots_server("rolePlots_ui_1")
