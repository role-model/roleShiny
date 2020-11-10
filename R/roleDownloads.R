library(shiny)
library(shinyBS)

source("R/util.R")


roleDownloadsUI <- function(id) {
    ns <- NS(id)

    tags$div(
        class = "control-set",

        h3("Downloads"),
        tags$div(
            class = "down-group",
            tags$div(
                class = "down-link",
                actionLink("downSim", "click to download simulation")),
            tags$div(
                class = "down-link",
                actionLink("downScript", "click to download script")),
            tags$div(
                class = "down-link",
                actionLink("downPlots", "click to download plots"))
        )
    )
}


roleDownloadsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
    })
}
