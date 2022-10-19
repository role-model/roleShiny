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
  about_rmd <- file.path(system.file(package = 'roleShiny'), 'about.Rmd')
  about_html <- file.path(system.file(package = 'roleShiny'), 'about.html')
  about2_html <- file.path(system.file(package = 'roleShiny'), 'about2.html')
  rmarkdown::render(about_rmd, quiet = TRUE)
  xml2::write_html(rvest::html_node(xml2::read_html(about_html), "body"), file = about2_html)
  
  
  tabPanel(title = "About",
           includeHTML(about2_html))
  
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
