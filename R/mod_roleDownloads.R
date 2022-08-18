#' roleDownloads UI Function
#'
#' @description A shiny Module for managing downloads.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import here shiny dplyr callr
#' @importFrom rmarkdown render
#' @importFrom uuid UUIDgenerate
#' @importFrom zip zip
#' @importFrom readr read_csv write_csv
#'


report_path <- tempfile(fileext = ".Rmd")
file.copy(here::here("inst/templates/report.Rmd"),
          report_path,
          overwrite = TRUE)

render_report <- function(input, output, params) {
  rmarkdown::render(
    here::here("inst/templates/report.Rmd"),
    output_file = output,
    params = params,
    envir = new.env(parent = globalenv())
  )
}

mod_roleDownloads_ui <- function(id) {
  ns <- NS(id)
  tagList(div(
    h3("Downloads"),
    
    div(
      downloadButton(ns("downSim"), "download simulation RDS object"),
      downloadButton(ns("downCSVs"), "download simulation CSVs"),
      downloadButton(ns("downScript"), "download script"),
      #downloadButton(ns("downPlots"), "download plots")
    )
  ))
}

#' roleDownloads Server Functions
#'
#' @noRd
mod_roleDownloads_server <- function(id, allSims) {
  moduleServer(id, function(input, output, session) {
    
    sim_id <- reactive({
      uuid::UUIDgenerate()
    }) 
    
      
      csv_list <- reactiveValues()
    
      
      # obtain data sets for all relevant output, including local traits, local abundances, meta traits, meta abundances, parameters
      
      meta <- reactive({
        allSims()$meta@experimentMeta
      }) 
      
      params <- reactive({
        allSims()$mod@params
      }) 
      
      sumstats <- reactive({
        
        ss <- getSumStats(
          allSims()$mod,
          funs = list(
            hillAbund = hillAbund,
            rich = richness,
            hillTrait = hillTrait
          ),
          moreArgs = list(hillAbund = list(q = 1:3),
                          hillTrait = list(q = 1:3))
        )
        ss[, "gen"] <- allSims()$meta@experimentMeta$generations
        
        
        return(ss)
      }) 
      
      
      
      raw <- reactive({
        ss <- getSumStats(
          allSims()$mod,
          funs = list(
            abund = rawAbundance,
            traits = rawTraits,
          ),
          moreArgs = list(hillAbund = list(q = 1:3),
                          hillTrait = list(q = 1:3))
        )
        ss[, "gen"] <- allSims()$meta@experimentMeta$generations
        
        return(ss)
      }) 
      
      
      # add reactive dataframes to csv list
      csv_list$meta <- meta
      
      csv_list$sumstats <- sumstats
    
      #### NEED TO USE uuid PACKAGE TO APPLY A UNIQUE NAME TO THE DOWNLOAD
      output$downSim <- downloadHandler(
        filename = function() {
          paste("sim-", file_suffix(), ".rds", sep = "")
        },
        content = function(file) {
          saveRDS(allSims(), file)
        }
      )
      
      
      output$downCSVs <- downloadHandler(
        filename = function() {
          
          paste("spreadsheets_", sim_id(), ".zip", sep = "")
        },
        content = function(file) {
          # create tempdir to write files temporarily
          temp_directory <- file.path(tempdir(), sim_id())
          dir.create(temp_directory)
          
          csv_list_raw <- reactiveValuesToList(csv_list)
          
          df_names <- names(csv_list_raw)
          
          # write to a temporary directory to zip
          for (i in 1:length(csv_list_raw)) {
            if (!is.null(csv_list_raw[[i]])) {
              file_name <- paste0(df_names[[i]], "_", sim_id(), ".csv")
              readr::write_csv(csv_list_raw[[i]](),
                               file.path(temp_directory, file_name))
            }
          }
          
          # zip the files
          zip::zip(
            zipfile = file,
            files = dir(temp_directory),
            root = temp_directory
          )
        },
        contentType = "application/zip"
      )
      
      output$downScript <- downloadHandler(
        filename = "report.html",
        content = function(file) {
          params <- list(
            j = input$j,
            jm = input$jm,
            sm = input$sm,
            nu = input$nu,
            num = input$num,
            ext = input$ext,
            trait_sigma = input$trait_sigma,
            env_sigma = input$env_sigma,
            comp_sigma = input$comp_sigma,
            m = input$m,
            mu = input$mu,
            eq = input$eq,
            bp = input$bp,
            type = input$type,
            iter = input$iter
          )
          
          for (i in 1:length(params)) {
            if (is.null(params[[i]])) {
              params[[i]] <- "NULL"
            }
          }
          
          id <- showNotification("Rendering report...",
                                 duration = NULL,
                                 closeButton = FALSE)
          on.exit(removeNotification(id), add = TRUE)
          
          callr::r(render_report,
                   list(
                     input = report_path,
                     output = file,
                     params = params
                   ))
          
          #render_report(input = report_path, output = file, params = params)
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
