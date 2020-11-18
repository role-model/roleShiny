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


roleControlButtonsServer <- function(id, selectCount) {
    moduleServer(id, function(input, output, session) {

        observe({
            shinyjs::toggleState("playBtn", canPlay(selectCount))
            shinyjs::toggleState("pauseBtn", canPause(selectCount))
            shinyjs::toggleState("nextBtn", canNext(selectCount))
        })

        observeEvent(input$playBtn, {play()}, ignoreInit = TRUE)

        observeEvent(input$pauseBtn, {pause()}, ignoreInit = TRUE)

        observeEvent(input$nextBtn, {next_()}, ignoreInit = TRUE)
    })
}
