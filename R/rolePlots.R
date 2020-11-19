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
        observe({
            if (canPlot() && input[[checkBox]]) {
                params <- list(
                    species_meta = input$sm,
                    individuals_meta = input$jm,
                    individuals_local = input$j,
                    dispersal_prob = input$m,
                    speciation_local = input$nu)

                roleComm <- func(params, nstep = input$nstep, nsim = input$nsim)

                # Handle demo output vvvvvvvvvvvvvvvvvvvvvvv DELETE ME
                shortest <- min(c(length(roleComm$meta_comm), length(roleComm$local_comm)))
                length(roleComm$meta_comm) <- shortest
                length(roleComm$local_comm) <- shortest
                # Handle demo output ^^^^^^^^^^^^^^^^^^^^^^^ DELETE ME

                lists <- list(meta_comm = roleComm$meta_comm, local_comm = roleComm$local_comm)
                df <- as.data.frame(lists)
                output[[name]] <- renderPlotly({
                    plot_ly(df, x = ~meta_comm, y = ~local_comm, type = "scatter", mode = "markers")
                })
            }
        })
    })
}
