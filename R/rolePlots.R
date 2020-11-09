library(shiny)
library(shinyBS)


source("R/util.R")


rolePlotsUI <- function(id, name) {
    ns <- NS(id)

    fluidRow(
        conditionalPanel(
            paste0("input.", name, "DistCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(5, plotlyOutput(paste0(name, "Dist", collapse = "")))
        ),
        conditionalPanel(
            paste0("input.", name, "TimeCheck", collapse = ""),
            class = "cond-panel",
            ns = ns,
            column(7, plotlyOutput(paste0(name, "Time", collapse = "")))
        )
    )
}
