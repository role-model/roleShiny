library(shiny)
library(shinyBS)
library(plotly)
library(roleR)

source("R/util.R")

rolePlotsUI <- function(id, name1, name2, check1, check2) {
    ns <- NS(id)

    fluidRow(

        conditionalPanel(check1, class = "cond-panel", ns = ns,
                         column(5, plotlyOutput(ns(name1)))
        ),

        conditionalPanel(check2, class = "cond-panel", ns = ns,
                         column(7, plotlyOutput(ns(name2)))
        )
    )
}

rolePlotsServer <- function(id, name, func, checkBox) {
    moduleServer(id, function(input, output, session) {
    })
}
