#' roleNeutral UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_roleNeutral_ui <- function(id){
  ns <- NS(id)
    tabPanel(title = "Neutral",
             sidebarLayout(
               fluid = FALSE,
               sidebarPanel(
                 mod_roleParamsNeutral_ui(ns(id)),
                 mod_roleControls_ui(ns(id)),
                 #mod_rolePlotSelects_ui(ns(id)),
                 mod_roleDownloads_ui(ns(id)),
                 #mod_roleUploads_ui(ns(id)),
                 width = 3
               ),
               
               mainPanel(
                 h2("Plots"),
                 
                 mod_rolePlots_ui(ns(id)),
                 
                 width = 9
               )
             )
  )
}
    
#' roleNeutral Server Functions
#'
#' @noRd 
mod_roleNeutral_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # temporary path to house simulations
    sims_out <- tempfile(pattern = "sims", tmpdir = tempdir(), fileext = ".rds")
    
    # roleSims
    mod_roleSims_server(id, sims_out = sims_out, is_neutral = TRUE)
    
    # roleReadSims
    allSims <- mod_roleReadSims_server(id, sims_out = sims_out)
    
    # roleParams
    mod_roleParamsNeutral_server(id)
    
    # roleControls
    mod_roleControls_server(id)
    
    # roleDownloads
    mod_roleDownloads_server(id, allSims = allSims)
    
    # rolePlotSelects
    #mod_rolePlotSelects_server(id)
    
    # roleUploads
    mod_roleUploads_server(id)
    
    # rolePlots
    mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out)
    
  })
}
    
## To be copied in the UI
# mod_roleNeutral_ui("roleNeutral_1")
    
## To be copied in the server
# mod_roleNeutral_server("roleNeutral_1")
