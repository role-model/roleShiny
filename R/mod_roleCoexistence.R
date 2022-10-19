#' roleCoexistence UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny 


mod_roleCoexistence_ui <- function(id) {
  ns <- NS(id)
  
  tabPanel(title = "Coexistence",
           sidebarLayout(
             fluid = FALSE,
             sidebarPanel(
               mod_roleControls_ui(ns(id)),
               mod_roleParamsCoexistence_ui(ns(id)),
               #mod_rolePlotSelects_ui(ns(id)),
               mod_roleDownloads_ui(ns(id)),
               #mod_roleUploads_ui(ns(id)),
               width = 3
             ),
             
             mainPanel(h2("Plots"),
                       
                       mod_rolePlots_ui(ns(id), has_traits = TRUE),
                       width = 9
                       
                       )
           ))
}
    
#' roleCoexistence Server Functions
#'
#' @noRd 
mod_roleCoexistence_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # temporary path to house simulations
    sims_out_coexistence <- tempfile(pattern = "sims_coexistence", tmpdir = tempdir(), fileext = ".rds")
    
    # roleSims
    mod_roleSims_server(id, sims_out = sims_out_coexistence, is_neutral = FALSE)
    
    # roleReadSims
    allSims <- mod_roleReadSims_server(id, sims_out = sims_out_coexistence)
    
    # roleParams
    mod_roleParamsCoexistence_server(id)
    
    # roleControls
    mod_roleControls_server(id)
    
    # roleDownloads
    mod_roleDownloads_server(id, allSims = allSims)
    
    # rolePlotSelects
    #mod_rolePlotSelects_server(id)
    
    # roleUploads
    mod_roleUploads_server(id)
    
    # rolePlots
    mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out_coexistence)
    
  })
}
    
## To be copied in the UI
# mod_roleCoexistence_ui("roleCoexistence_1")
    
## To be copied in the server
# mod_roleCoexistence_server("roleCoexistence_1")
