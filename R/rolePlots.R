library(shiny)
library(shinyBS)
library(plotly)
library(roleR)


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


rolePlotsServer <- function(id, name) {
    moduleServer(id, function(input, output, session) {
        output[[name]] <- renderPlotly({
            params <- list(
                species_meta = input$sm,
                individuals_meta = input$jm,
                individuals_local = input$j,
                dispersal_prob = input$m,
                speciation_local = input$nu)
            roleComm <- roleSim(params, nstep = input$nstep, nsim = input$nsim)
            lists <- list(meta_comm = roleComm$meta_comm, local_comm = roleComm$local_comm)
            df <- as.data.frame(lists)
            plot_ly(df, x = ~local_comm, y = ~meta_comm, type = "scatter", mode = "markers")
        })
    })
}
