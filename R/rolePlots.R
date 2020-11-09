library(shiny)
library(shinyBS)
library(plotly)


source("R/util.R")


rolePlotsUI <- function(id, name) {
    ns <- NS(id)

    fluidRow(
        conditionalPanel(
            paste0("input.", name, "DistCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(5, plotlyOutput(ns(paste0(name, "Dist", collapse = ""))))
        ),
        conditionalPanel(
            paste0("input.", name, "TimeCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(7, plotlyOutput(ns(paste0(name, "Time", collapse = ""))))
        )
    )
}


rolePlotsServer <- function(id, name) {
    moduleServer(id, function(input, output, session) {
        output[[paste0(name, "Dist", collapse = "")]] <- renderPlotly({
            plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
        })
        output[[paste0(name, "Time", collapse = "")]] <- renderPlotly({
            plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
        })
    })
}
