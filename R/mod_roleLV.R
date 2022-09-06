#' roleLV UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny 


mod_roleLV_ui <- function(id) {
  ns <- NS(id)
  
  tabPanel(title = "Lotka-Volterra",
           sidebarLayout(
             fluid = FALSE,
             sidebarPanel(
               mod_roleControls_ui(ns(id)),
               mod_roleParamsLV_ui(ns(id)),
               #mod_rolePlotSelects_ui(ns(id)),
               mod_roleDownloads_ui(ns(id)),
               #mod_roleUploads_ui(ns(id)),
               width = 2
             ),
             
             mainPanel(h2("Plots"),
                       
                       mod_rolePlots_ui(ns(id)),
                       width = 10
                       
             )
           ))
}

#' roleLV Server Functions
#'
#' @noRd 
mod_roleLV_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # temporary path to house simulations
    sims_out_lv <- tempfile(pattern = "sims_lv", tmpdir = tempdir(), fileext = ".rds")
    
    # roleSims
    mod_roleSims_server(id, sims_out = sims_out_lv, is_neutral = FALSE)
    
    # roleReadSims
    allSims <- mod_roleReadSims_server(id, sims_out = sims_out_lv)
    
    # roleParams
    mod_roleParamsLV_server(id)
    
    # roleControls
    mod_roleControls_server(id)
    
    # roleDownloads
    mod_roleDownloads_server(id, allSims = allSims)
    
    # rolePlotSelects
    #mod_rolePlotSelects_server(id)
    
    # roleUploads
    mod_roleUploads_server(id)
    
    # rolePlots
    mod_rolePlots_server(id, allSims = allSims, sims_out = sims_out_lv)
    
  })
}

## To be copied in the UI
# mod_roleLV_ui("roleLV_1")

## To be copied in the server
# mod_roleLV_server("roleLV_1")
