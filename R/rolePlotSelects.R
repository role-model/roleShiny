library(shiny)
library(shinyBS)

source("R/util.R")


rolePlotSelectsUI <- function(id) {
    ns <- NS(id)

    tags$div(
        class = "control-set",

        h3("Plots"),
        tags$div(
            class = "plot-group",
            HTML('<div class="plot-row-1 plot-col-2">distri&shy;bution</div>'),
            tags$div(class = "plot-row-1 plot-col-3", "time series"),

            tags$div(class = "plot-row-2 plot-col-1", "abundance"),
            tags$div(class = "plot-row-2 plot-col-2", checkboxInput(ns("abundDistChk"), label = "")),
            tags$div(class = "plot-row-2 plot-col-3", checkboxInput(ns("abundTimeChk"), label = "")),

            tags$div(class = "plot-row-3 plot-col-1", "traits"),
            tags$div(class = "plot-row-3 plot-col-2", checkboxInput(ns("traitDistChk"), label = "")),
            tags$div(class = "plot-row-3 plot-col-3", checkboxInput(ns("traitTimeChk"), label = "")),

            tags$div(class = "plot-row-4 plot-col-1", "genetic div"),
            tags$div(class = "plot-row-4 plot-col-2", checkboxInput(ns("geneDistChk"), label = "")),
            tags$div(class = "plot-row-4 plot-col-3", checkboxInput(ns("geneTimeChk"), label = "")),

            bsTooltip(ns("abundDistChk"), "Display the abundance distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("abundTimeChk"), "Display the abundance time plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("abundDistChk"), "Display the trait distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("traitTimeChk"), "Display the trait time plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("geneDistChk"), "Display the genetic diversity distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("geneTimeChk"), "Display the genetic diversity time plot", placement = "bottom", trigger = "hover"),
        )
    )
}


rolePlotSelectsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
    })
}

