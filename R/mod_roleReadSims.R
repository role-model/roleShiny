#' roleReadSims UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny
mod_roleReadSims_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' roleReadSims Server Functions
#'
#' @noRd 
mod_roleReadSims_server <- function(id, sims_out){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # if() statement to depend on a file being there

    # reactiveFileReader to read in the output simulation
    # else the output object is a blank object
    
    sims <-  reactiveFileReader(10, session, filePath = sims_out, readFunc = readRDS) %>% 
      bindEvent(input$playBtn)
    
    return(sims)
    
  })
}
    
## To be copied in the UI
# mod_roleReadSims_ui("roleReadSims_1")
    
## To be copied in the server
# mod_roleReadSims_server("roleReadSims_1")
