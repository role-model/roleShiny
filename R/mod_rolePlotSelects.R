#' rolePlotSelects UI Function
#'
#' @description A shiny Module controlling  plot inputs. 
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_rolePlotSelects_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "control-set",
      
      h3("Plots"),
      div(
        class = "plot-group",
        HTML('<div class="plot-row-1 plot-col-2">distri&shy;bution</div>'),
        div(class = "plot-row-1 plot-col-3", "time series"),
        
        div(class = "plot-row-2 plot-col-1", "abundance"),
        div(class = "plot-row-2 plot-col-2", checkboxInput(ns("abundDistChk"), label = "")),
        div(class = "plot-row-2 plot-col-3", checkboxInput(ns("abundTimeChk"), label = "")),
        
        div(class = "plot-row-3 plot-col-1", "traits"),
        div(class = "plot-row-3 plot-col-2", checkboxInput(ns("traitDistChk"), label = "")),
        div(class = "plot-row-3 plot-col-3", checkboxInput(ns("traitTimeChk"), label = "")),
        
        div(class = "plot-row-4 plot-col-1", "genetic div"),
        div(class = "plot-row-4 plot-col-2", checkboxInput(ns("geneDistChk"), label = "")),
        div(class = "plot-row-4 plot-col-3", checkboxInput(ns("geneTimeChk"), label = "")),
        
        bsTooltip(ns("abundDistChk"), "Display the abundance distribution plot"),
        bsTooltip(ns("abundTimeChk"), "Display the abundance time plot"),
        bsTooltip(ns("traitDistChk"), "Display the trait distribution plot"),
        bsTooltip(ns("traitTimeChk"), "Display the trait time plot"),
        bsTooltip(ns("geneDistChk"), "Display the genetic diversity distribution plot"),
        bsTooltip(ns("geneTimeChk"), "Display the genetic diversity time plot"),
      )
    )
  )
}
    
#' rolePlotSelects Server Functions
#'
#' @noRd 
mod_rolePlotSelects_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
 
  })
}
    
## To be copied in the UI
# mod_rolePlotSelects_ui("rolePlotSelects_ui_1")
    
## To be copied in the server
# mod_rolePlotSelects_server("rolePlotSelects_ui_1")
