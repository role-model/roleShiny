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
            roleParamsUI("roleControls"),
            roleControlButtonsUI("roleControls"),
            rolePlotSelectsUI("roleControls"),
            roleDownloadsUI("roleControls"),
        ),
        mainPanel(
            h1("Rules of Life Engine model"),
            rolePlotsUI("roleControls", prefix = "abund"),
            rolePlotsUI("roleControls", prefix = "trait"),
            rolePlotsUI("roleControls", prefix = "gene"),
        )
    )
)


server <- function(input, output, session) {
    rolePlotsServer("roleControls", name = "abundDist")
    rolePlotsServer("roleControls", name = "abundTime")
    rolePlotsServer("roleControls", name = "traitDist")
    rolePlotsServer("roleControls", name = "traitTime")
    rolePlotsServer("roleControls", name = "geneDist")
    rolePlotsServer("roleControls", name = "geneTime")
}


shinyApp(ui, server)
