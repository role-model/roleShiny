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
      actionButton(ns("pauseBtn"), icon("pause")),
      actionButton(ns("nextBtn"), icon("step-forward")),
      shinyBS::bsTooltip(ns("playBtn"), "Play the simulation", placement = "bottom", trigger = "hover"),
      shinyBS::bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
      shinyBS::bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
      )
    )
}
    
#' roleControls Server Functions
#'
#' @noRd 
mod_roleControls_server <- function(id, allSims){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    observeEvent(input$playBtn, {
      # sims <- getSims(input, allSims)
      # something in place until I figure out what the allSims() reactiveVal is for
      sims <- sort(rpois(100, round(runif(1, 1, 100))), decreasing = TRUE)
      print("before")
      #untar("./data/MESS-simulated-data_small.tar.gz", list = TRUE)
      # X <- read.csv(MESS-simulated-data/params-sim-data.txt)
      # print(files)
      print("after")
      # params <- list(species_meta = 100,
      #                individuals_meta = 10000,
      #                individuals_local = 1000,
      #                dispersal_prob = 0.1,
      #                speciation_local = 0.01)
      # testSim <- roleSimPlay(params, nstep = 100, nout = 5)
      # print(testSim)
    }, ignoreInit = TRUE)
    
    observeEvent(input$pauseBtn, {
    }, ignoreInit = TRUE)
    
    observeEvent(input$nextBtn, {
    }, ignoreInit = TRUE)
  })
}
    
## To be copied in the UI
# mod_roleControls_ui("roleControls_ui_1")
    
## To be copied in the server
# mod_roleControls_server("roleControls_ui_1")
