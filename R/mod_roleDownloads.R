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
file.copy(here::here("inst/templates/report.Rmd"), report_path, overwrite = TRUE)

render_report <- function(input, output, params) {
  
  rmarkdown::render(here::here("inst/templates/report.Rmd"),
                    output_file = output,
                    params = params,
                    envir = new.env(parent = globalenv())
  )
}

mod_roleDownloads_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      
      h3("Downloads"),
      
      div(
        
        downloadButton(ns("downSim"), "download simulation RDS object"),
        downloadButton(ns("downCSVs"), "download simulation CSVs"),
        downloadButton(ns("downScript"), "download script"),
        #downloadButton(ns("downPlots"), "download plots")
      )
    )
  )
}
    
#' roleDownloads Server Functions
#'
#' @noRd 
mod_roleDownloads_server <- function(id, allSims) {
  moduleServer(id, function(input, output, session) {
    
    csv_list <- reactiveValues()
    
   sim_id <- reactive({
     uuid::UUIDgenerate()
   }) %>% 
      bindEvent(input$playBtn)
    
    # obtain data sets for all relevant output, including local traits, local abundances, meta traits, meta abundances, parameters
    traits <- reactive({
      get_traits(allSims()) %>%
        sample_ts(n_ts = length(allSims()$com_t), is_abund = FALSE) %>% 
        mutate(sim_id = sim_id())
    }) %>%
      bindEvent(input$playBtn)
      
    
    abundances <- reactive({
      get_abund(allSims()) %>%
        sample_ts(n_ts = length(allSims()$com_t)) %>% 
        mutate(sim_id = sim_id())
    }) %>% bindEvent(input$playBtn)
      


    meta_abund <- reactive({
      get_meta_abund(allSims()) %>% 
        mutate(sim_id = sim_id())
    }) %>% 
      bindEvent(input$playBtn)
      

    meta_traits <- reactive({
      get_meta_traits(allSims()) %>% 
        mutate(sim_id = sim_id())
    }) %>% 
      bindEvent(input$playBtn)
    
    # calculate abundance sumstats for the last timestep
    abund_sumstats <- reactive({
      req(abundances)
      
      abund_sum <- abundances() %>% 
        group_by(timestep) %>% 
        summarize(
          species_richness = hill_calc(ab, order = 0),
          mean = mean(ab),
          median = median(ab),
          standard_deviation = sd(ab),
          shannon = entropy::entropy(ab),
          hill_1 = hill_calc(ab, order = 1),
          hill_2 = hill_calc(ab, order = 2),
          hill_3 = hill_calc(ab, order = 3),
          hill_4 = hill_calc(ab, order = 4),
          hill_5 = hill_calc(ab, order = 5)
        ) %>% 
        mutate(sim_id = sim_id())
      
      return(abund_sum)
    }) %>% 
      bindEvent(input$playBtn)
    
    # calculate trait sumstats for the last timestep
    trait_sumstats <- reactive({
      req(traits)
      
      trait_sum <- traits() %>% 
        group_by(timestep) %>% 
        summarize(
          mean = mean(trait),
          median = median(trait),
          standard_deviation = sd(trait),
          variance = var(trait),
          shannon = entropy::entropy(trait),
          hill_1 = hill_calc(trait, order = 1),
          hill_2 = hill_calc(trait, order = 2),
          hill_3 = hill_calc(trait, order = 3),
          hill_4 = hill_calc(trait, order = 4),
          hill_5 = hill_calc(trait, order = 5)
        ) %>% 
        mutate(sim_id = sim_id())
      
      return(trait_sum)
    }) %>% 
      bindEvent(input$playBtn)
    
    # parameters df
    param_df <- reactive({
      if (input$env_filt == "Stabilizing") {
          param_df <- data.frame(
            jm = input$jm,
            sm = input$sm,
            j = input$j,
            m = input$m,
            nstep = input$nstep,
            filt_mean = input$filt_mean,
            filt_sd = input$filt_sd
          ) %>% 
          mutate(sim_id = sim_id())
    
      } else {
        param_df <- 
          data.frame(
            jm = input$jm,
            sm = input$sm,
            j = input$j,
            m = input$m,
            nstep = input$nstep
          ) %>% 
          mutate(sim_id = sim_id())
      }
      
      return(param_df)
      
    }) %>% 
      bindEvent(input$playBtn)
    
    # add reactive dataframes to csv list
    csv_list$traits <- traits
    csv_list$abundances <- abundances
    csv_list$meta_abund <- meta_abund
    csv_list$meta_traits <- meta_traits
    csv_list$abund_sumstats <- abund_sumstats
    csv_list$trait_sumstats <- trait_sumstats
    csv_list$params <- param_df
    
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
      filename = function(){
        paste("spreadsheets_", Sys.Date(), ".zip", sep = "")
      },
      content = function(file){
        
        # create tempdir to write files temporarily
        temp_directory <- file.path(tempdir(), sim_id())
        dir.create(temp_directory)
  
        csv_list_raw <- reactiveValuesToList(csv_list)
        
        df_names <- names(csv_list_raw)
        
        # write to a temporary directory to zip
        for (i in 1:length(csv_list_raw)) {
          if (!is.null(csv_list_raw[[i]])) {
            file_name <- paste0(df_names[[i]], "_", sim_id(), ".csv")
            readr::write_csv(csv_list_raw[[i]](), file.path(temp_directory, file_name))
          }
        }
        
        # zip the files
        zip::zip(
          zipfile = file,
          files = dir(temp_directory),
          root = temp_directory
        )
      },
      contentType = "application/zip")
    
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
    
  }
  )
  }


  
## To be copied in the UI
# mod_roleDownloads_ui("roleDownloads_ui_1")
    
## To be copied in the server
# mod_roleDownloads_server("roleDownloads_ui_1")
