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

id <- "roleControls"

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
    
    params <- reactive({list(
      species_meta = input[[ns("sm")]],
      individuals_meta = input[[ns("jm")]],
      individuals_local = input[[ns("j")]],
      dispersal_prob = input[[ns("m")]],
      speciation_local = input[[ns("nu")]])})
    
    observe({
      reactive({
        s <- sort(rpois(params$individuals_local(), params$species_meta()), decreasing = TRUE)
        data.frame(x = 1:length(s), y = s, sim = c(rep("A", length(s))))
        }
        ) %>% 
        bindEvent(input$plyBtn)
      
    }) 
    
  })
}
    
## To be copied in the UI
# mod_roleSims_ui("roleSims_1")
    
## To be copied in the server
# mod_roleSims_server("roleSims_1")
