#' roleMESS UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_roleMESS_ui <- function(id){
  ns <- NS(id)
  tabPanel(title = "The Full MESS",
           sidebarLayout(
             fluid = FALSE,
             sidebarPanel(
               mod_roleControls_ui(ns(id)),
               mod_roleParamsMESS_ui(ns(id)),
               #mod_rolePlotSelects_ui(ns(id)),
               mod_roleDownloads_ui(ns(id)),
               #mod_roleUploads_ui(ns(id)),
               width = 2
             ),
             
             mainPanel(h2("Plots"),
                       
                       mod_rolePlots_ui(ns(id), has_phylo = TRUE),
                       width = 10
                       
             )
           ))
}

#' roleMESS Server Functions
#'
#' @noRd 
mod_roleMESS_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # temporary path to house simulations
    sims_out_MESS <- tempfile(pattern = "sims_MESS", tmpdir = tempdir(), fileext = ".rds")
    
    # roleSims
    mod_roleSims_server(id, sims_out = sims_out_MESS, is_neutral = FALSE)
    
    # roleReadSims
    allSims <- mod_roleReadSims_server(id, sims_out = sims_out_MESS)
    
    # roleParams
    mod_roleParamsMESS_server(id)
    
    # roleControls
    mod_roleControls_server(id)
    
    # roleDownloads
    mod_roleDownloads_server(id, allSims = allSims)
    
    # rolePlotSelects
    #mod_rolePlotSelects_server(id)
    
    # roleUploads
    mod_roleUploads_server(id)
    
    # rolePlots
    mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out_MESS, has_phylo = TRUE)
    
  })
}
