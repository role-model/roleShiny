#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny shinyjs bslib
#' @importFrom shinyWidgets switchInput
#' @noRd

id_a <- "about"
id_n <- "neutral"
id_c <- "coexistence"
id_m <- "mess"
id_lv <- "lv"

light <- bslib::bs_theme(version = 5, bootswatch = "flatly")
dark <- bslib::bs_theme(version = 5, bootswatch = "darkly")

app_ui <- function(request) {
  
  
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # tags$script(src = "ui.js"),
    # tags$style(src = "all.min.css"),
    # shinyjs::useShinyjs(),
    # Your application UI logic 
    navbarPage("Rules of Life Engine",
               theme = light,
               mod_roleAbout_ui(id_a),
               mod_roleNeutral_ui(id_n),
               mod_roleLV_ui(id_lv),
               mod_roleCoexistence_ui(id_c),
               mod_roleMESS_ui(id_m),
               bslib::nav_spacer(),
               bslib::nav_item(shinyWidgets::materialSwitch("dark_mode", "", status = "success")),
               
      ),
      
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

