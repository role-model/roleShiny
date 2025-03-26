#' roleNeutral UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny 

mod_roleNeutral_ui <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    fluid = TRUE,
    sidebarPanel(
      mod_roleControls_ui(ns(id)),
      mod_roleParamsNeutral_ui(ns(id)),
      width = 4
    ),
    mainPanel(
      h2("Plots"),
      mod_rolePlots_ui(ns(id)),
      width = 8
    )
  )
}

#' roleNeutral Server Functions
#'
#' @noRd
mod_roleNeutral_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    sims_out_neutral <- tempfile(pattern = "sims_neutral_", tmpdir = tempdir(), fileext = ".rds")
    
    allSims <- mod_roleSims_server(id, sims_out = sims_out_neutral, is_neutral = TRUE)
    
    mod_roleParamsNeutral_server(id)
    mod_roleControls_server(id)
    mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out_neutral)
  })
}
