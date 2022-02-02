roleUploadsUI <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "control-set",
    
    h3("Uploads"),
    
    tags$div(
      class = "up-group",
      
      fileInput(ns("upSim"), "upload simulation(s)",
                multiple = TRUE,
                accept = c(".csv")),
      
      textOutput(ns("contents"))
      
    )
  )
  
}


roleUploadsServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
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
