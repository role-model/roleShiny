#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' 
library(here)

id <- "roleControls"

app_server <- function(input, output, session) {
  
  # move away from list()
  # currSims <- reactiveVal(data.frame())
  # allSims <- reactiveFileReader(10, session,
  #                               filePath = "~/Desktop/test_data.csv",
  #                               readFunc = read.csv)
  
  # temporary path to house simulations
  sims_out <- tempfile(pattern = "sims", tmpdir = here("inst", "sims"), fileext = ".csv")
  
  mod_roleSims_server(id, sims_out = sims_out)
  allSims <- mod_roleReadSims_server(id, sims_out = sims_out)
  mod_roleParams_server(id)
  mod_roleControls_server(id)
  mod_rolePlotSelects_server(id)
  mod_roleDownloads_server(id)
  mod_roleUploads_server(id)
  
  mod_rolePlots_server(id, name = "abundDist", func = roleDistAnim, type = "Abundance", checkBox = "abundDistChk", allSims = allSims)
  mod_rolePlots_server(id, name = "abundTime", func = roleTSAnim, type = "Abundance", checkBox = "abundTimeChk", allSims = allSims)
  mod_rolePlots_server(id, name = "traitDist", func = roleDistAnim, type = "Trait", checkBox = "traitDistChk", allSims = allSims)
  mod_rolePlots_server(id, name = "traitTime", func = roleTSAnim, type = "Trait", checkBox = "traitTimeChk", allSims = allSims)
  mod_rolePlots_server(id, name = "geneDist", func = roleDistAnim, type = "pi", checkBox = "geneDistChk", allSims = allSims)
  mod_rolePlots_server(id, name = "geneTime", func = roleTSAnim, type = "pi", checkBox = "geneTimeChk", allSims = allSims)

  
  }
