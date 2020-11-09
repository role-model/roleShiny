library(shiny)

moduleServer <- function(id, module) {
    callModule(module, id)
}
