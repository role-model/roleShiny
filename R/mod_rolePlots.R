#' rolePlots UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session,name1,name2,check1,check2,name,func,type,checkBox,allSims Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny plotly roleR ggplot2 highcharter magrittr
#' @importFrom dplyr left_join
#' 
library(magrittr)

mod_rolePlots_ui <- function(id,
                             has_traits = FALSE,
                             has_phylo = FALSE
                             ){
  ns <- NS(id)
  tagList(
    tags$head(tags$style(".rightAlign{float:right;}")),
    tabsetPanel(
      type = "tabs",
      tabPanel("Abundances", 
               fluidRow(
                 column(width = 5, 
                        plotlyOutput(ns("abundRank"))
                        ),
               column(width = 5, 
                      plotlyOutput(ns("abundTime")),
                      uiOutput(ns("abundYvar"), class = "rightAlign")
                      )
               )
               ),
      
      if (has_traits) {
        tabPanel("Traits", 
                 fluidRow(
                   column(width = 5, 
                          plotlyOutput(ns("traitRank"))
                   ),
                   column(width = 5, 
                          plotlyOutput(ns("traitTime"))
                   )
                 )
        )
      }
      ,
      if (has_phylo) {
        tabPanel("Phylogenetics",
                 fluidRow(
                   column(width = 8,
                          plotlyOutput(ns("phylo"))
                   )
                 )
                 )
      }
      
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
                                 allSims, 
                                 has_phylo = FALSE){
  

  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # nest these if() statements in an if() statement that checks if allSims() is of a certain size (or class. Maybe I can make the empty allSims its own class to clear us of having to worry about unusable data sizes)
    
    
    observe({
      
      req(allSims())
      
      sumstats <- reactive({

        ss <- getSumStats(allSims()$mod, 
                    funs = list(abund = rawAbundance, 
                                hillAbund = hillAbund, 
                                rich = richness,
                                traits = rawTraits,
                                hillTrait = hillTrait), 
                    moreArgs = list(hillAbund = list(q = 1:3)))
        ss[,"gen"] <- round(allSims()$meta@experimentMeta$generations, 1)
        
        return(ss)
      })
      
      meta <- reactive({
        slot(allSims()$meta, "experimentMeta")
      })
      
      raw <- reactive({
        abund <- tidy_raw_rank(sumstats(), "abund")
        traits <- tidy_raw_rank(sumstats(), "traits")
        
        return(list(abund = abund, traits = traits))
      })  
      
      ### Abund rank fig ###
      
      # y-axis choices 
      output$abundYvar <- renderUI({
        radioButtons(
          ns("abundYvar"),
          label = "",
          choiceNames = c("Hill 1", "Hill 2", "Hill 3", "All Hill #s"),
          choiceValues = c("hillAbund_1", "hillAbund_2", "hillAbund_3", "all_hill"),
          inline = TRUE
        )
      })
        
        fig_abundRank <-  reactive({
          
          abund_rank <- raw()$abund
          
          p <- gg_scatter(dat = abund_rank, yvar = "abund", is_abund = TRUE)
            
          return(p)
          
        })
      
        output$abundRank <- renderPlotly({
          fig_abundRank()
        })
        
        ### Abund time fig ###
        
        fig_abundTime <-  reactive({
          
          plotly_ts(dat = sumstats(), yvar = input$abundYvar)
    
        }) 
        
        output$abundTime <- renderPlotly({
          fig_abundTime()
        })
      
        ### Trait rank fig ###
        
        fig_traitRank <- reactive({
        
          trait_rank <- raw()$traits
          
          p <- gg_scatter(dat = trait_rank, yvar = "traits", is_abund = FALSE)
          
          return(p)
        })
        
        output$traitRank <- renderPlotly({
          fig_traitRank()
        })
        
       ### Trait time fig ###
        
        fig_traitTime <- reactive({
          
          plotly_ts(dat = sumstats(), yvar = "hillTrait_1")
          
        })
        
        output$traitTime <- renderPlotly({
          fig_traitTime()
        })
        
        if (has_phylo) {
          fig_phylo <- reactive({
            
            plotly_phylo()
            
          })
          
          output$phylo <- renderPlotly({
            fig_phylo()
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
