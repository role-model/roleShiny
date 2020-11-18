library(shiny)
library(shinyBS)
library(shinyjs)

source("R/util.R")


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
        canPlay <- reactiveVal(TRUE)
        canPause <- reactiveVal(FALSE)
        canNext <- reactiveVal(FALSE)

        observe({
            shinyjs::toggleState("playBtn", canPlay() && selectCount() > 0)
            shinyjs::toggleState("pauseBtn", canPause() && selectCount() > 0)
            shinyjs::toggleState("nextBtn", canNext() && selectCount() > 0)
        })

        observeEvent(input$playBtn, {
            canPlay(FALSE)
            canPause(TRUE)
            canNext(FALSE)
        })

        observeEvent(input$pauseBtn, {
            canPlay(TRUE)
            canPause(FALSE)
            canNext(TRUE)
        })

        observeEvent(input$nextBtn, {
            canPlay(TRUE)
            canPause(FALSE)
            canNext(TRUE)
        })
    })
}
