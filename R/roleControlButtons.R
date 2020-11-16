library(shiny)
library(shinyBS)

source("R/util.R")


roleControlButtonsUI <- function(id) {
    ns <- NS(id)
    tags$div(
        class = "control-set but-group",
        actionButton(ns("playBtn"), label = "\u23F5"),
        actionButton(ns("pauseBtn"), label = "\u23F8"),
        actionButton(ns("nextBtn"), label = "\u23ed"),
        bsTooltip(ns("playBtn"), "Play the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
    )
}


roleControlButtonsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        play <- observeEvent(input$playBtn, {
            print(input$playBtn)
        })
        pause <- observeEvent(input$pauseBtn, {
            print(input$pauseBtn)
        })
        next_ <- observeEvent(input$nextBtn, {
            print(input$nextBtn)
        })
    })
}
