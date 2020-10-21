library(shiny)
library(ggplot2)
library(plotly)


server <- function(input, output) {
    # sm <- reactive({rnorm(input$sm)})
    # jm <- reactive({rnorm(input$jm)})
    # j <- reactive({rnorm(input$j)})
    # m <- reactive({rnorm(input$m)})
    # nu <- reactive({rnorm(input$nu)})

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
