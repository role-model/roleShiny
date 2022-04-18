#' roleControls UI Function
#'
#' @description A shiny Module for controlling simulation progress.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom shinyBS bsTooltip
#' 


mod_roleControls_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "control-set but-group",
      actionButton(ns("playBtn"), icon("play")),
      # actionButton(ns("pauseBtn"), icon("pause")),
      # actionButton(ns("nextBtn"), icon("step-forward")),
      
      shinyBS::bsTooltip(ns("playBtn"), "Play the simulation", placement = "center", trigger = "hover")
      # shinyBS::bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
      # shinyBS::bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
      )
    )
}
    
#' roleControls Server Functions
#'
#' @noRd 
mod_roleControls_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
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
