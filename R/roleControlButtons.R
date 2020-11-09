library(shiny)
library(shinyBS)

source("R/util.R")


roleControlButtonsUI <- function(id) {
    ns <- NS(id)
    tags$div(
        class = "control-set but-group",
        actionButton(ns("play"), label = "\u23F5"),
        actionButton(ns("pause"), label = "\u23F8"),
        actionButton(ns("next"), label = "\u23ed"),
        bsTooltip(ns("play"), "Play the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("pause"), "Pause the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("next"), "Step simulation forward", placement = "bottom", trigger = "hover")
    )
}


roleControlButtonsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
    })
}
