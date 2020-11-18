library(shiny)
library(shinyBS)
library(shinyjs)

source("R/util.R")
source("R/roleAppState.R")


roleControlButtonsUI <- function(id) {
    ns <- NS(id)
    tags$div(
        class = "control-set but-group",
        tags$div(class = "playWrap", actionButton(ns("playBtn"), label = "\u23F5")),
        tags$div(class = "pauseWrap", actionButton(ns("pauseBtn"), label = "\u23F8")),
        tags$div(class = "nextWrap", actionButton(ns("nextBtn"), label = "\u23ed")),
        bsTooltip(ns("playBtn"), "Play the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
    )
}


roleControlButtonsServer <- function(id, appState, selectCount) {
    moduleServer(id, function(input, output, session) {

        observe({
            shinyjs::toggleState("playBtn", appState$canPlay() && selectCount() > 0)
            shinyjs::toggleState("pauseBtn", appState$canPause() && selectCount() > 0)
            shinyjs::toggleState("nextBtn", appState$canNext() && selectCount() > 0)
        })

        observeEvent(input$playBtn, {play(appState)}, ignoreInit = TRUE)

        observeEvent(input$pauseBtn, {pause(appState)}, ignoreInit = TRUE)

        observeEvent(input$nextBtn, {next_(appState)}, ignoreInit = TRUE)
    })
}
