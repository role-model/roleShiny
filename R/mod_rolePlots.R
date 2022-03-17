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

mod_rolePlots_ui <- function(id, name1, name2, check1, check2){
  ns <- NS(id)
  tagList(
    fluidRow(
      
      conditionalPanel(check1, class = "cond-panel", ns = ns,
                       column(5, plotOutput(ns(name1)))
      ),
      
      conditionalPanel(check2, class = "cond-panel", ns = ns,
                       column(7, plotOutput(ns(name2)))
      )
    )
  )
}
    
#' rolePlots Server Functions
#'
#' @noRd 
mod_rolePlots_server <- function(id, name, func, type, checkBox, allSims){
  
  #stopifnot(is.reactive(allSims))
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
      # explore ways to change this if statement to return something
      if (input[[checkBox]]) {
        #cat("rolePlotsServer", length(allSims()), "\n")
      #allSims <- mod_roleSims_server(id)
      # fig <- allSims() %>%
      #       plot_ly(x = ~x, y = ~y) %>%
      #       add_lines(color = ~ordered(sim)) %>%
      #       layout(xaxis = list(title = "Rank"), yaxis = list(title = "Abundance"))
        fig <- plot(1:10, 1:10)
      } else fig <- plot(1:5, 1:5)
        output[[name]] <- renderPlot({fig})
    }) %>% 
      bindEvent(input$plyBtn)
    
  })
}
    
## To be copied in the UI
# mod_rolePlots_ui("rolePlots_ui_1")
    
## To be copied in the server
# mod_rolePlots_server("rolePlots_ui_1")
