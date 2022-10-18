#' roleAbout UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#'
#' @import markdown 
#' @import here
#' @importFrom xml2 write_html read_html
#' @importFrom rvest html_node


mod_roleAbout_ui <- function(id) {
  ns <- NS(id)
  about_file <- file.path(system.file(package = 'roleShiny'), 'about.html')
  
  tabPanel(title = "About",
           includeHTML(about_file))
  
}

#' roleAbout Server Functions
#'
#' @noRd
mod_roleAbout_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
  })
}

## To be copied in the UI
# mod_roleAbout_ui("roleAbout_1")

## To be copied in the server
# mod_roleAbout_server("roleAbout_1")
