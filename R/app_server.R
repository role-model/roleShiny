#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' 


id <- "roleControls"

app_server <- function(input, output, session) {
  
  # move away from list()
  # currSims <- reactiveVal(data.frame())
  # allSims <- reactiveFileReader(10, session,
  #                               filePath = "~/Desktop/test_data.csv",
  #                               readFunc = read.csv)
  
  allSims <- mod_roleSims_server(id)
  
  mod_roleParams_server(id)
  mod_roleControls_server(id, reactive(allSims))
  mod_rolePlotSelects_server(id)
  mod_roleDownloads_server(id)
  mod_roleUploads_server(id)
  
  mod_rolePlots_server(id, name = "abundDist", func = roleDistAnim, type = "Abundance", checkBox = "abundDistChk", allSims = reactive(allSims))
  mod_rolePlots_server(id, name = "abundTime", func = roleTSAnim, type = "Abundance", checkBox = "abundTimeChk", allSims = reactive(allSims))
  mod_rolePlots_server(id, name = "traitDist", func = roleDistAnim, type = "Trait", checkBox = "traitDistChk", allSims = reactive(allSims))
  mod_rolePlots_server(id, name = "traitTime", func = roleTSAnim, type = "Trait", checkBox = "traitTimeChk", allSims = reactive(allSims))
  mod_rolePlots_server(id, name = "geneDist", func = roleDistAnim, type = "pi", checkBox = "geneDistChk", allSims = reactive(allSims))
  mod_rolePlots_server(id, name = "geneTime", func = roleTSAnim, type = "pi", checkBox = "geneTimeChk", allSims = reactive(allSims))

  
  }
