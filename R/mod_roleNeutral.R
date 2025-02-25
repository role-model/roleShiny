#' roleNeutral UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny 
#' 



mod_roleNeutral_ui <- function(id) {
  ns <- NS(id)
  tabPanel(title = "Neutral",
           sidebarLayout(
             fluid = FALSE,
             sidebarPanel(
               mod_roleControls_ui(ns(id)),
               mod_roleParamsNeutral_ui(ns(id)),
               #mod_rolePlotSelects_ui(ns(id)),
               width = 3
             ),
             
             mainPanel(h2("Plots"),
                       
                       #mod_rolePlots_ui(ns(id)),
                       
                       width = 9)
           ))
}

#' roleNeutral Server Functions
#'
#' @noRd
mod_roleNeutral_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    # temporary path to house simulations
    sims_out_neutral <-
      tempfile(pattern = "sims_neutral_",
               tmpdir = tempdir(),
               fileext = ".rds")
    
    # roleSims
    allSims <- mod_roleSims_server(id, sims_out = sims_out_neutral, is_neutral = TRUE)
    
    # roleReadSims, little confused on what this does
    # allSims <-
    #   mod_roleReadSims_server(id, sims_out = sims_out_neutral)
    
    # roleParams
    mod_roleParamsNeutral_server(id)
    
    # roleControls: handles run button, need to implement more
    mod_roleControls_server(id)
    
    # rolePlotSelects: plot selects on the sidebar, need to trace more
    #mod_rolePlotSelects_server(id)
    
    # rolePlots: handles displaying the actual plots
    #mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out_neutral)
    
  })
}
