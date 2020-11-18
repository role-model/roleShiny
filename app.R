library(shiny)
library(shinyBS)
library(shinyjs)
library(plotly)

source("R/roleParams.R")
source("R/roleControls.R")
source("R/rolePlotSelects.R")
source("R/roleDownloads.R")
source("R/rolePlots.R")
source("R/roleAppState.R")


id <- "roleControls"


ui <- fluidPage(
    theme = "ui.css",
    tags$script(src = "ui.js"),
    useShinyjs(),

    sidebarLayout(
        sidebarPanel(
            roleParamsUI(id),
            roleControlButtonsUI(id),
            rolePlotSelectsUI(id),
            roleDownloadsUI(id),
        ),
        mainPanel(
            h1("Rules of Life Engine model"),

            rolePlotsUI( id,  name1 = "abundDist", name2 = "abundTime",
                         check1 = "input.abundDistChk", check2 = "input.abundTimeChk"),

            rolePlotsUI(id, name1 = "traitDist", name2 = "traitTime",
                        check1 = "input.traitDistChk", check2 = "input.traitTimeChk"),

            rolePlotsUI(id, name1 = "geneDist", name2 = "geneTime",
                        check1 = "input.geneDistChk", check2 = "input.geneTimeChk"),
        )
    )
)


server <- function(input, output, session) {
    selectCount <- rolePlotSelectsServer(id)
    roleControlButtonsServer(id, selectCount)
    roleParamsServer(id)
    roleDownloadsServer(id)

    rolePlotsServer(id, name = "abundDist", func = roleSim)
    rolePlotsServer(id, name = "abundTime", func = roleSim)
    rolePlotsServer(id, name = "traitDist", func = roleSim)
    rolePlotsServer(id, name = "traitTime", func = roleSim)
    rolePlotsServer(id, name = "geneDist", func = roleSim)
    rolePlotsServer(id, name = "geneTime", func = roleSim)
}


shinyApp(ui, server)
