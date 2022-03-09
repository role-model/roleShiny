#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' 


id <- "roleControls"

app_server <- function(input, output, session) {
  allSims <- reactiveVal(list())
  currSims <- reactiveVal(list())
  
  mod_roleParams_server(id)
  mod_roleControls_server(id, allSims)
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
