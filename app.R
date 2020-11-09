library(shiny)
library(shinyBS)
library(ggplot2)
library(plotly)


source("R/roleParams.R")
source("R/roleControlButtons.R")
source("R/rolePlotSelects.R")
source("R/roleDownloads.R")
source("R/rolePlots.R")


server <- function(input, output, session) {
    # sm <- reactive({rnorm(input$sm)})
    # jm <- reactive({rnorm(input$jm)})
    # j <- reactive({rnorm(input$j)})
    # m <- reactive({rnorm(input$m)})
    # nu <- reactive({rnorm(input$nu)})

    roleParamServer("sm")

    output$abundDist <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers")
    })
    output$abundTime <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
    })

    output$traitDist <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers")
    })
    output$traitTime <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
    })

    output$geneDist <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers")
    })
    output$geneTime <- renderPlotly({
        plot_ly(iris, x = ~Petal.Length, y = ~Sepal.Length, type = "scatter", mode = "markers", color = ~Species)
    })

}

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

shinyApp(ui, server)
