#' roleReadSims UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_roleReadSims_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' roleReadSims Server Functions
#'
#' @noRd 
mod_roleReadSims_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_roleReadSims_ui("roleReadSims_1")
    
## To be copied in the server
# mod_roleReadSims_server("roleReadSims_1")
