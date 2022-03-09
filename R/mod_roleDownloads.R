#' roleDownloads UI Function
#'
#' @description A shiny Module for managing downloads.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 
#' 
report_path <- tempfile(fileext = ".Rmd")
file.copy(here::here("inst/templates/report.Rmd"), report_path, overwrite = TRUE)

render_report <- function(input, output, params) {
  rmarkdown::render(input,
                    output_file = output,
                    params = params,
                    envir = new.env(parent = globalenv())
  )
}

mod_roleDownloads_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "control-set",
      
      h3("Downloads"),
      
      div(
        class = "down-group",
        
        downloadButton(ns("downSim"), "download simulation"),
        downloadButton(ns("downScript"), "download script"),
        downloadButton(ns("downPlots"), "download plots")
      )
    )
  )
}
    
#' roleDownloads Server Functions
#'
#' @noRd 
mod_roleDownloads_server <- function(id){
  moduleServer(id, function(input, output, session) {
    
    output$downSim <- downloadHandler(
      filename = function() {
        paste("sim-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(mtcars, file)
      }
    )
    
    output$downScript <- downloadHandler(
      filename = "report.html",
      content = function(file) {
        params <- list(n = 10)
        
        id <- showNotification(
          "Rendering report...", 
          duration = NULL, 
          closeButton = FALSE
        )
        on.exit(removeNotification(id), add = TRUE)
        
        callr::r(render_report,
                 list(input = report_path, output = file, params = params)
        )
      }
    )
    
    output$downPlots <- downloadHandler(
      filename = function() {
        paste("plots-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(mtcars, file)
      }
    )
    
  })
}
    
## To be copied in the UI
# mod_roleDownloads_ui("roleDownloads_ui_1")
    
## To be copied in the server
# mod_roleDownloads_server("roleDownloads_ui_1")
