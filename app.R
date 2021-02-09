library(shiny)
library(shinyBS)
library(shinyjs)
library(plotly)
library(plyr)
library(future)
# library(roleR)

source("R/roleParams.R")
source("R/roleControls.R")
source("R/rolePlotSelects.R")
source("R/roleDownloads.R")
source("R/rolePlots.R")

source("R/roleSimsPlots.R")  # Temporary module


id <- "roleControls"


ui <- fluidPage(
    theme = "ui.css",
    tags$script(src = "ui.js"),
    tags$style(src = "all.min.css"),
    useShinyjs(),

    sidebarLayout(
        sidebarPanel(
            roleParamsUI(id),
            roleControlsUI(id),
            rolePlotSelectsUI(id),
            roleDownloadsUI(id),
        ),

        mainPanel(
            h1("Rules of Life Engine model"),

            rolePlotsUI(id,  name1 = "abundDist", name2 = "abundTime",
                        check1 = "input.abundDistChk", check2 = "input.abundTimeChk"),

            rolePlotsUI(id, name1 = "traitDist", name2 = "traitTime",
                        check1 = "input.traitDistChk", check2 = "input.traitTimeChk"),

            rolePlotsUI(id, name1 = "geneDist", name2 = "geneTime",
                        check1 = "input.geneDistChk", check2 = "input.geneTimeChk"),
        )
    )
)


getSims <- function(input, allSims) {
    ns <- NS(id)
    observe({
        nstep <- input[[ns("nstep")]]

        if (!is.null(allSims()) && length(allSims()) < nstep) {
            nout <- input[[ns("nout")]]
            nstep <- min(nstep, nout * input[[ns("nvis")]])
            nout <- input[[ns("nout")]]
            params <- list(
                species_meta = input[[ns("sm")]],
                individuals_meta = input[[ns("jm")]],
                individuals_local = input[[ns("j")]],
                dispersal_prob = input[[ns("m")]],
                speciation_local = input[[ns("nu")]])

            init <- if (length(allSims()) == 0) NULL else allSims()[[length(allSims())]]

            f <- future({
                roleSimPlay(params, init = init, nstep = nstep, nout = nout)
            }, seed = TRUE)

            f
        }
    })
}


server <- function(input, output, session) {
    allSims <- reactiveVal(list())
    currSims <- reactiveVal(list())

    roleParamsServer(id)
    roleControlsServer(id, allSims)
    rolePlotSelectsServer(id)
    roleDownloadsServer(id)

    rolePlotsServer(id, name = "abundDist", func = roleDistAnim, type = "Abundance", checkBox = "abundDistChk", allSims = allSims)
    rolePlotsServer(id, name = "abundTime", func = roleTSAnim, type = "Abundance", checkBox = "abundTimeChk", allSims = allSims)
    rolePlotsServer(id, name = "traitDist", func = roleDistAnim, type = "Trait", checkBox = "traitDistChk", allSims = allSims)
    rolePlotsServer(id, name = "traitTime", func = roleTSAnim, type = "Trait", checkBox = "traitTimeChk", allSims = allSims)
    rolePlotsServer(id, name = "geneDist", func = roleDistAnim, type = "pi", checkBox = "geneDistChk", allSims = allSims)
    rolePlotsServer(id, name = "geneTime", func = roleTSAnim, type = "pi", checkBox = "geneTimeChk", allSims = allSims)

    fut <- getSims(input, allSims)
    print(fut)
    fut
}


shinyApp(ui, server)
