library(shiny)
library(shinyBS)
library(plotly)


source("R/util.R")
# source("R/roleSim.R")


rolePlotsUI <- function(id, prefix) {
    ns <- NS(id)

    fluidRow(
        conditionalPanel(
            paste0("input.", prefix, "DistCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(5, plotlyOutput(ns(paste0(prefix, "Dist", collapse = ""))))
        ),
        conditionalPanel(
            paste0("input.", prefix, "TimeCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(7, plotlyOutput(ns(paste0(prefix, "Time", collapse = ""))))
        )
    )
}


rolePlotsServer <- function(id, name, paramsNS = "roleParams") {
    moduleServer(id, function(input, output, session) {
        paramNs <- NS(paramsNS)
        output[[name]] <- renderPlotly({
            params <- list(
                species_meta = input$sm,
                individuals_meta = input$jm,
                individuals_local = input$j,
                dispersal_prob = input$m,
                speciation_local = input$nu)
            # accum <- roleSim(params, nstep = input$nstep, nsim = input$nsim)
            plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
        })
    })
}
