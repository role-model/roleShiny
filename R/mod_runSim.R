#' roleControls UI Function
#'
#' @description A shiny Module for controlling simulation progress.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny
#' @importFrom shinyBS bsTooltip
#' 

mod_roleControls_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$style(HTML(sprintf("
      #%s_csvUpload {
        display: none;
      }
    ", ns("")))),
    
    # Hidden file input
    fileInput(ns("csvUpload"), "Import CSV File", accept = ".csv"),
    
    # Centered button using flexbox
    div(
      style = "display: flex; justify-content: center; margin-top: 10px;",
      actionButton(ns("runBtn"), "Run Simulation", class = "btn-primary", width = "200px")
    ),
    
    hr()
  )
}

#' roleControls Server Functions
#'
#' @noRd 
mod_roleControls_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$csvUpload, {
      req(input$csvUpload)
      
      tryCatch({
        # Attempt to read and validate the CSV
        param_df <- read.csv(input$csvUpload$datapath, stringsAsFactors = FALSE)
        
        # Validate required columns
        if (!all(c("param", "value") %in% names(param_df))) {
          stop("CSV missing required 'param' and 'value' columns.")
        }
        
        # Create a lookup list from the dataframe
        param_list <- setNames(param_df$value, param_df$param)
        
        # Update each input (handle both sliders and numerics)
        for (param in names(param_list)) {
          val <- suppressWarnings(as.numeric(param_list[[param]]))
          
          try(updateSliderInput(session, param, value = val), silent = TRUE)
          try(updateNumericInput(session, paste0(param, "_t"), value = val), silent = TRUE)
        }
        
        # Update dropdown separately
        if (!is.null(param_list[["type"]])) {
          try(updateSelectInput(session, "type", selected = param_list[["type"]]), silent = TRUE)
        }
        
      }, error = function(e) {
        showNotification("Incorrect .csv format. Please include 'param' and 'value' columns.", type = "error")
        message("[CSV Import Error] ", e$message)
      })
    })
  })
}


## To be copied in the UI
# mod_roleControls_ui("roleControls_ui_1")

## To be copied in the server
# mod_roleControls_server("roleControls_ui_1")
