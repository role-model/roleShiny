#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

# library(shiny)
# library(shinyBS)
# library(shinyjs)
# library(plotly)
# library(dplyr)
# library(callr)
# library(roleR)
# library(here)

id <- "roleControls"

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      theme = "ui.css",
      tags$script(src = "ui.js"),
      tags$style(src = "all.min.css"),
      shinyjs::useShinyjs(),
      
      sidebarLayout(
        sidebarPanel(
          mod_roleParams_ui(id),
          mod_roleControls_ui(id),
          mod_rolePlotSelects_ui(id),
          mod_roleDownloads_ui(id),
          mod_roleUploads_ui(id)
        ),
        
        mainPanel(
          h1("Rules of Life Engine model"),
          
          
          mod_rolePlots_ui(id,  name1 = "abundDist", name2 = "abundTime",
                           check1 = "input.abundDistChk", check2 = "input.abundTimeChk"),
          
          mod_rolePlots_ui(id, name1 = "traitDist", name2 = "traitTime",
                           check1 = "input.traitDistChk", check2 = "input.traitTimeChk"),
          
          mod_rolePlots_ui(id, name1 = "geneDist", name2 = "geneTime",
                           check1 = "input.geneDistChk", check2 = "input.geneTimeChk"),
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'roleShiny'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

