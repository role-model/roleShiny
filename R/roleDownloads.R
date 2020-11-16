library(shiny)
library(shinyBS)

source("R/util.R")


roleDownloadsUI <- function(id) {
    tags$div(
        class = "control-set",

        h3("Downloads"),

        tags$div(
            class = "down-group",
            tags$div(
                class = "down-link",
                actionLink("downSimLink", "click to download simulation")),
            tags$div(
                class = "down-link",
                actionLink("downScriptLink", "click to download script")),
            tags$div(
                class = "down-link",
                actionLink("downPlotsLink", "click to download plots"))
        )
    )
}


roleDownloadsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        downSim <- observeEvent(input$downSimLink, {
            print(input$downSimLink)
        })
        downScript <- observeEvent(input$downScriptLink, {
            print(input$downScriptLink)
        })
        downPlots <- observeEvent(input$downPlotsLink, {
            print(input$downPlotsLink)
        })
    })
}
