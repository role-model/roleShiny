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

            bsTooltip(ns("abundDistChk"), "Display the abundance distribution plot"),
            bsTooltip(ns("abundTimeChk"), "Display the abundance time plot"),
            bsTooltip(ns("traitDistChk"), "Display the trait distribution plot"),
            bsTooltip(ns("traitTimeChk"), "Display the trait time plot"),
            bsTooltip(ns("geneDistChk"), "Display the genetic diversity distribution plot"),
            bsTooltip(ns("geneTimeChk"), "Display the genetic diversity time plot"),
        )
    )
}


setSelectCount <- function(selectCount, checkBox) {
    bump <- if (checkBox) 1 else -1
    count = max(0, selectCount() + bump)
    selectCount(count)
}


rolePlotSelectsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        selectCount <- reactiveVal(0)

        observeEvent(input$abundDistChk, {
            setSelectCount(selectCount, input$abundDistChk)
        })

        observeEvent(input$abundTimeChk, {
            setSelectCount(selectCount, input$abundDistChk)
        })

        observeEvent(input$traitDistChk, {
            setSelectCount(selectCount, input$traitDistChk)
        })

        observeEvent(input$traitTimeChk, {
            setSelectCount(selectCount, input$traitTimeChk)
        })

        observeEvent(input$geneDistChk, {
            setSelectCount(selectCount, input$geneDistChk)
        })

        observeEvent(input$geneTimeChk, {
            setSelectCount(selectCount, input$geneTimeChk)
        })

        selectCount
    })
}

