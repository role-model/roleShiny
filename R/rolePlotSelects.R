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
            tags$div(class = "plot-row-2 plot-col-2", checkboxInput(ns("abundDistCheck"), label = "")),
            tags$div(class = "plot-row-2 plot-col-3", checkboxInput(ns("abundTimeCheck"), label = "")),

            tags$div(class = "plot-row-3 plot-col-1", "traits"),
            tags$div(class = "plot-row-3 plot-col-2", checkboxInput(ns("traitDistCheck"), label = "")),
            tags$div(class = "plot-row-3 plot-col-3", checkboxInput(ns("traitTimeCheck"), label = "")),

            tags$div(class = "plot-row-4 plot-col-1", "genetic div"),
            tags$div(class = "plot-row-4 plot-col-2", checkboxInput(ns("geneDistCheck"), label = "")),
            tags$div(class = "plot-row-4 plot-col-3", checkboxInput(ns("geneTimeCheck"), label = "")),

            bsTooltip(ns("abundDistCheck"), "Display the abundance distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("abundTimeCheck"), "Display the abundance time plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("abundDistCheck"), "Display the trait distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("traitTimeCheck"), "Display the trait time plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("geneDistCheck"), "Display the genetic diversity distribution plot", placement = "bottom", trigger = "hover"),
            bsTooltip(ns("geneTimeCheck"), "Display the genetic diversity time plot", placement = "bottom", trigger = "hover"),
        )
    )
}
