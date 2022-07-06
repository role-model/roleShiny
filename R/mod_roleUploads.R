#' roleUploads UI Function
#'
#' @description A Shiny module for uploading files.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_roleUploads_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      
      #h3("Uploads"),
      
      div(
        fileInput(ns("upSim"), "upload simulation(s)",
                  multiple = TRUE,
                  accept = c(".csv")),
        
        textOutput(ns("contents"))
        
      )
    )
  )
  
}
    
#' roleUploads Server Functions
#'
#' @noRd 

mod_roleUploads_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$contents <- renderPrint({
      
      # require an input before starting
      req(input$upSim)
      
      df_list <- vector(mode = "list", length = length(input$upSim[,1]))
      
      # temporarily only accepting csv files
      for(i in 1:length(input$upSim[,1])){
        df_list[[i]] <- read.csv(input$upSim[[i, 'datapath']])
      }
      
      paste("Number of files = ", length(df_list))
      
    })
    
    
  })
}

    
## To be copied in the UI
# mod_roleUploads_ui("roleUploads_ui_1")
    
## To be copied in the server
# mod_roleUploads_server("roleUploads_ui_1")
