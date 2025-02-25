#' roleSims UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#'
#' @noRd 
#'
#' @import shiny roleR 
#' @importFrom shinybusy show_modal_spinner remove_modal_spinner
#' 



mod_roleSims_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' roleSims Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param sims_out Path to temporary file to house simulations
#'
#' @noRd 
#' @import shiny roleR

mod_roleSims_server <- function(id, sims_out, is_neutral = TRUE){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    s <- reactive({
      shinybusy::show_modal_spinner(text = "May take a while for larger models")
      
      if(is_neutral) {
        
        params <- untbParams(
          individuals_local = input$j,
          individuals_meta = input$jm,
          species_meta = input$sm,
          speciation = input$nu,
          dispersal_prob = input$m,
          init_type = input$type,
          niter = input$iter,
          niterTimestep = 10
        )
        
        exp <- roleModel(params)
        
        m <- runRole(exp)
        
        
      } else if(is_neutral == FALSE) {
        params <- roleParams(
          individuals_local = input$j,
          individuals_meta = input$jm,
          species_meta = input$sm,
          speciation_local = input$nu,
          speciation_meta = 1,
          extinction_meta = 0.8,
          trait_sigma = input$trait_sigma,
          env_sigma = 1,
          comp_sigma = 1,
          dispersal_prob = input$m,
          mutation_rate = 0.01,
          equilib_escape = 1,
          num_basepairs = 250,
          init_type = 'oceanic_island',
          niter = input$iter
        )
        
        exp <- roleModel(params)
        
        m <- runRole(exp)
      }
      
      shinybusy::remove_modal_spinner()
      return(m)
      
      }) %>%
      bindEvent(input$playBtn)
    
    
    # observe({
    #   s()
    #   saveRDS(s(), file = sims_out)
    # }) %>% 
    #   bindEvent(input$playBtn)
    
      
      
  })
}

## To be copied in the UI
# mod_roleSims_ui("roleSims_1")
    
## To be copied in the server
# mod_roleSims_server("roleSims_1")
