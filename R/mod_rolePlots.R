#' rolePlots UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session,name1,name2,check1,check2,name,func,type,checkBox,allSims Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
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
mod_rolePlots_server <- function(id, name, func, type, checkBox, allSims){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
      if (length(allSims()) > 0 && input[[checkBox]]) {
        cat("rolePlotsServer", length(allSims()), "\n")
        fig <- func(allSims(), type)
        output[[name]] <- renderPlotly({fig})
      }
    })
  })
}
    
## To be copied in the UI
# mod_rolePlots_ui("rolePlots_ui_1")
    
## To be copied in the server
# mod_rolePlots_server("rolePlots_ui_1")
