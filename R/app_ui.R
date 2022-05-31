#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

id <- "roleControls"

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    navbarPage("Rules of Life Engine",
      theme = "ui.css",
      tags$script(src = "ui.js"),
      tags$style(src = "all.min.css"),
      shinyjs::useShinyjs(),
      tabPanel("Neutral",
               sidebarLayout(
                 sidebarPanel(
                   mod_roleParamsNeutral_ui(id),
                   mod_roleControls_ui(id),
                   #mod_rolePlotSelects_ui(id),
                   mod_roleDownloads_ui(id),
                   #mod_roleUploads_ui(id)
                 ),
                 
                 mainPanel(
                   h1("Plots"),
                   
                   mod_rolePlots_ui(id)
                   
                   # tabsetPanel(type = "tabs",
                   #   tabPanel("Abundances", mod_rolePlots_ui(id,  name1 = "abundDist", name2 = "abundTime",
                   #                    check1 = "input.abundDistChk", check2 = "input.abundTimeChk")),
                   #   
                   #   tabPanel("Traits", mod_rolePlots_ui(id, name1 = "traitDist", name2 = "traitTime",
                   #                    check1 = "input.traitDistChk", check2 = "input.traitTimeChk")),
                   #   
                   #   tabPanel("Genes", mod_rolePlots_ui(id, name1 = "geneDist", name2 = "geneTime",
                   #                    check1 = "input.geneDistChk", check2 = "input.geneTimeChk"))
                 )
               )
      ),
      tabPanel("Coexistence",
               sidebarLayout(
                 sidebarPanel(
                   mod_roleParamsCoexistence_ui(id),
                   mod_roleControls_ui(id),
                   #mod_rolePlotSelects_ui(id),
                   mod_roleDownloads_ui(id),
                   #mod_roleUploads_ui(id)
                 ),
                 
                 mainPanel(
                   h1("Plots"),
                   
                   mod_rolePlots_ui(id)
                  
                 )
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

