library(shiny)
library(shinyBS)
library(ggplot2)
library(plotly)


source("R/roleParams.R")
source("R/roleControlButtons.R")
source("R/rolePlotSelects.R")
source("R/roleDownloads.R")
source("R/rolePlots.R")


ui <- fluidPage(
    theme = "ui.css",
    tags$script(src = "ui.js"),

    sidebarLayout(
        sidebarPanel(
            roleParamsUI("roleParams"),
            roleControlButtonsUI("roleControls"),
            rolePlotSelectsUI("roleControls"),
            roleDownloadsUI("roleControls"),
        ),
        mainPanel(
            h1("Rules of Life Engine model"),
            rolePlotsUI("roleControls", "abund"),
            rolePlotsUI("roleControls", "trait"),
            rolePlotsUI("roleControls", "gene"),
        )
    )
)


server <- function(input, output, session) {
    rolePlotsServer("roleControls", "abund")
    rolePlotsServer("roleControls", "trait")
    rolePlotsServer("roleControls", "gene")
}


shinyApp(ui, server)
