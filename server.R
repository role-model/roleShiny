library(shiny)
library(ggplot2)
library(dplyr)


count1 <- sort(sample.int(40, 200, replace = TRUE), decreasing = TRUE)
site1 <- data.frame(count1)
site1$rank1 <- 1:nrow(site1)

count2 <- sort(sample.int(100, 1000, replace = TRUE), decreasing = TRUE)
site2 <- data.frame(count2)
site2$rank2 <- 1:nrow(site2)

count3 <- sort(sample.int(50, 100, replace = TRUE), decreasing = TRUE)
site3 <- data.frame(count3)
site3$rank3 <- 1:nrow(site3)


server <- function(input, output) {
  # sm <- reactive({rnorm(input$sm)})
  jm <- reactive({rnorm(input$jm)})
  j <- reactive({rnorm(input$j)})
  m <- reactive({rnorm(input$m)})
  nu <- reactive({rnorm(input$nu)})

  output$abundDist <- renderPlot({
    ggplot(site1, aes(x = rank1, y = round(log10(count1), 1))) +
      geom_point(size = 2, shape = 1) +
      scale_y_continuous(trans = 'log10')
  })
  output$abundTime <- renderPlot({
    ggplot(site1, aes(x = rank1, y = log10(count1))) +
      geom_line()
  })

  output$traitDist <- renderPlot({
    ggplot(site2, aes(x = rank2, y = round(log10(count2), 1))) +
      geom_point(size = 2, shape = 1) +
      scale_y_continuous(trans = 'log10')
  })
  output$traitTime <- renderPlot({
    ggplot(site2, aes(x = rank2, y = log10(count2))) +
      geom_line()
  })

  output$geneDist <- renderPlot({
    ggplot(site3, aes(x = rank3, y = round(log10(count3), 1))) +
      geom_point(size = 2, shape = 1) +
      scale_y_continuous(trans = 'log10')
  })
  output$geneTime <- renderPlot({
    ggplot(site3, aes(x = rank3, y = log10(count3))) +
      geom_line()
  })

}
