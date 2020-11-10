library(shiny)
library(shinyBS)
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
    rolePlotsServer("roleControls", name = "abundDist", func = roleSim)
    rolePlotsServer("roleControls", name = "abundTime", func = roleSim)
    rolePlotsServer("roleControls", name = "traitDist", func = roleSim)
    rolePlotsServer("roleControls", name = "traitTime", func = roleSim)
    rolePlotsServer("roleControls", name = "geneDist", func = roleSim)
    rolePlotsServer("roleControls", name = "geneTime", func = roleSim)
}


shinyApp(ui, server)
