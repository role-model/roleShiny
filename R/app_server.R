#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' 
library(here)

id_n <- "neutral"
id_c <- "coexistence"

app_server <- function(input, output, session) {
  mod_roleNeutral_server(id_n)
  mod_roleCoexistence_server(id_c)
  
  }
