#' roleAbout UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom htmltools includeMarkdown
#' @import markdown
#' @import here


mod_roleAbout_ui <- function(id) {
  ns <- NS(id)
  rmarkdown::render(here("about.Rmd"), quiet = TRUE)
  
  tabPanel(title = "About",
           htmltools::includeHTML(here("about.html")))
  
}
    
#' roleAbout Server Functions
#'
#' @noRd 
mod_roleAbout_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_roleAbout_ui("roleAbout_1")
    
## To be copied in the server
# mod_roleAbout_server("roleAbout_1")
