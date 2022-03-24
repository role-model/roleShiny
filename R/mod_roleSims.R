#' roleSims UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 


mod_roleSims_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' roleSims Server Functions
#'
#' @noRd 
mod_roleSims_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
      # params <- reactiveValues()
      # params$species_meta <- input[[ns("sm")]]
      # params$individuals_meta <- input[[ns("jm")]]
      # params$individuals_local <- input[[ns("j")]]
      # params$dispersal_prob <- input[[ns("m")]]
      # params$speciation_local <-  input[[ns("nu")]
    
    
    p <- reactive({sort(rpois(input$sm, input$jm), decreasing = TRUE)})

    d <- reactive({data.frame(x = 1:length(p()), y = p(), sim = rep("A", length(p())))})
    
    return(d)
  })
}
    
## To be copied in the UI
# mod_roleSims_ui("roleSims_1")
    
## To be copied in the server
# mod_roleSims_server("roleSims_1")
