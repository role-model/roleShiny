library(shiny)
library(shinyBS)
library(plotly)
library(roleR)

source("R/util.R")

# Note: We draw the controls 2 at a time but serve them one at a time

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


rolePlotsServer <- function(id, name, func) {
    moduleServer(id, function(input, output, session) {

        df <- eventReactive(input$playBtn, {
            params <- list(
                species_meta = input$sm,
                individuals_meta = input$jm,
                individuals_local = input$j,
                dispersal_prob = input$m,
                speciation_local = input$nu)

            roleComm <- func(params, nstep = input$nstep, nsim = input$nsim)

            shortest <- min(c(length(roleComm$meta_comm), length(roleComm$local_comm)))
            length(roleComm$meta_comm) <- shortest
            length(roleComm$local_comm) <- shortest
            lists <- list(meta_comm = roleComm$meta_comm, local_comm = roleComm$local_comm)
            as.data.frame(lists)
        })

        output[[name]] <- renderPlotly({
            plot_ly(df(), x = ~meta_comm, y = ~local_comm, type = "scatter", mode = "markers")
        })
    })
}

