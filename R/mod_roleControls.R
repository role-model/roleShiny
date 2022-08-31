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
    div(
      br(),
      br(),
      br(),
      br(),
      h2("Run the simulation"),
      actionButton(ns("playBtn"), icon("play"), class = "btn-primary btn-lg"),
      # actionButton(ns("pauseBtn"), icon("pause")),
      # actionButton(ns("nextBtn"), icon("step-forward")),
      
      shinyBS::bsTooltip(ns("playBtn"), "Play the simulation", placement = "center", trigger = "hover"),
      # shinyBS::bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
      # shinyBS::bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
      hr()
      )
    )
}
    
#' roleControls Server Functions
#'
#' @noRd 
mod_roleControls_server <- function(id){
  moduleServer( id, function(input, output, session){
    
    #observeEvent(input$playBtn, {
    # allSims <- reactiveFileReader(10, session,
    #                        filePath = "~/Desktop/test_data.csv",
    #                        readFunc = read.csv)
    #}, ignoreInit = TRUE)
    
  #   observeEvent(input$pauseBtn, {
  #   }, ignoreInit = TRUE)
  #   
  #   observeEvent(input$nextBtn, {
  #   }, ignoreInit = TRUE)
   })
}
    
## To be copied in the UI
# mod_roleControls_ui("roleControls_ui_1")
    
## To be copied in the server
# mod_roleControls_server("roleControls_ui_1")
