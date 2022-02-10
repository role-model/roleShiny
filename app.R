library(shiny)
library(shinyBS)
library(shinyjs)
library(plotly)
library(dplyr)
library(future)
library(roleR)
library(here)

id <- "roleControls"


ui <- fluidPage(
    theme = "ui.css",
    tags$script(src = "ui.js"),
    tags$style(src = "all.min.css"),
    useShinyjs(),

    sidebarLayout(
        sidebarPanel(
            mod_roleParams_ui(id),
            mod_roleControls_ui(id),
            mod_rolePlotSelects_ui(id),
            mod_roleDownloads_ui(id),
            mod_roleUploads_ui(id)
        ),

        mainPanel(
            h1("Rules of Life Engine model"),
            
            
            mod_rolePlots_ui(id,  name1 = "abundDist", name2 = "abundTime",
                        check1 = "input.abundDistChk", check2 = "input.abundTimeChk"),

            mod_rolePlots_ui(id, name1 = "traitDist", name2 = "traitTime",
                        check1 = "input.traitDistChk", check2 = "input.traitTimeChk"),

            mod_rolePlots_ui(id, name1 = "geneDist", name2 = "geneTime",
                        check1 = "input.geneDistChk", check2 = "input.geneTimeChk"),
        )
    )
)


server <- function(input, output, session) {
    allSims <- reactiveVal(list())
    currSims <- reactiveVal(list())

    mod_roleParams_server(id)
    mod_roleControls_server(id, allSims)
    mod_rolePlotSelects_server(id)
    mod_roleDownloads_server(id)
    mod_roleUploads_server(id)
    
    mod_rolePlots_server(id, name = "abundDist", func = roleDistAnim, type = "Abundance", checkBox = "abundDistChk", allSims = allSims)
    mod_rolePlots_server(id, name = "abundTime", func = roleTSAnim, type = "Abundance", checkBox = "abundTimeChk", allSims = allSims)
    mod_rolePlots_server(id, name = "traitDist", func = roleDistAnim, type = "Trait", checkBox = "traitDistChk", allSims = allSims)
    mod_rolePlots_server(id, name = "traitTime", func = roleTSAnim, type = "Trait", checkBox = "traitTimeChk", allSims = allSims)
    mod_rolePlots_server(id, name = "geneDist", func = roleDistAnim, type = "pi", checkBox = "geneDistChk", allSims = allSims)
    mod_rolePlots_server(id, name = "geneTime", func = roleTSAnim, type = "pi", checkBox = "geneTimeChk", allSims = allSims)

}


shinyApp(ui, server)
