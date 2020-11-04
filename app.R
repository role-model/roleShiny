library(shiny)
library(shinyBS)
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


ui <- fluidPage(
    theme = "ui.css",

    tags$script(src = "ui.js"),

    sidebarLayout(

        sidebarPanel(

            tags$div(
                class = "control-set",
                h3("Parameters"),

                tags$div(class = "show-hide", bsButton("commonParams", label = "Common Parameters", type = "toggle", value = TRUE)),
                bsTooltip("commonParams", "Show/hide common parameters", placement = "bottom", trigger = "hover"),

                conditionalPanel(
                    "input.commonParams",
                    class = "cond-panel",

                    tags$div(
                        class = "param-group param-1",

                        HTML('<div class="param-label">S<sub>m</sub></div>'),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("sm", label = "", min = 0, max = 100, value = 20, ticks = FALSE),
                            bsTooltip("sm", "The Sm variable", placement = "bottom", trigger = "hover")
                        ),

                        HTML('<div class="param-label">J<sub>m</sub></div>'),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("jm", label = "", min = 0, max = 100, value = 30, ticks = FALSE),
                            bsTooltip("jm", "The Jm variable", placement = "bottom", trigger = "hover")
                        ),

                        tags$div(class = "param-label", "J"),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("j", label = "", min = 0, max = 100, value = 50, ticks = FALSE),
                            bsTooltip("j", "The J variable", placement = "bottom", trigger = "hover")
                        ),

                        tags$div(class = "param-label", "m"),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("m", label = "", min = 0, max = 100, value = 10, ticks = FALSE),
                            bsTooltip("m", "The m variable", placement = "bottom", trigger = "hover")
                        ),

                        HTML('<div class="param-label greek">&#957;</div>'),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("nu", label = "", min = 0, max = 100, value = 80, ticks = FALSE),
                            bsTooltip("nu", "The &#957; variable", placement = "bottom", trigger = "hover")
                        ),

                    ),
                ),

                tags$div(class = "show-hide", bsButton("extraParams", label = "Extra Parameters", type = "toggle")),
                bsTooltip("extraParams", "Show/hide extra parameters", placement = "bottom", trigger = "hover"),

                conditionalPanel(
                    "input.extraParams",
                    class = "cond-panel",

                    tags$div(
                        class = "param-group param-2",

                        HTML('<div class="param-label">A<sub>m</sub></div>'),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("am", label = "", min = 0, max = 100, value = 20, ticks = FALSE),
                            bsTooltip("am", "The Am variable", placement = "bottom", trigger = "hover")
                        ),

                        HTML('<div class="param-label">B<sub>m</sub></div>'),
                        tags$div(
                            class = "param-wrapper",
                            sliderInput("bm", label = "", min = 0, max = 100, value = 30, ticks = FALSE),
                            bsTooltip("bm", "The Bm variable", placement = "bottom", trigger = "hover")
                        ),
                    ),
                ),
            ),

            tags$div(
                class = "control-set but-group",
                actionButton("play", label = "\u23F5"),
                actionButton("pause", label = "\u23F8"),
                actionButton("next", label = "\u23ed"),
                bsTooltip("play", "Play the simulation", placement = "bottom", trigger = "hover"),
                bsTooltip("pause", "Pause the simulation", placement = "bottom", trigger = "hover"),
                bsTooltip("next", "Step simulation forward", placement = "bottom", trigger = "hover")
            ),

            tags$div(
                class = "control-set",

                h3("Plots"),
                tags$div(
                    class = "plot-group",
                    HTML('<div class="plot-row-1 plot-col-2">distri&shy;bution</div>'),
                    tags$div(class = "plot-row-1 plot-col-3", "time series"),

                    tags$div(class = "plot-row-2 plot-col-1", "abundance"),
                    tags$div(class = "plot-row-2 plot-col-2", checkboxInput("abundDistCheck", label = "")),
                    tags$div(class = "plot-row-2 plot-col-3", checkboxInput("abundTimeCheck", label = "")),

                    tags$div(class = "plot-row-3 plot-col-1", "traits"),
                    tags$div(class = "plot-row-3 plot-col-2", checkboxInput("traitDistCheck", label = "")),
                    tags$div(class = "plot-row-3 plot-col-3", checkboxInput("traitTimeCheck", label = "")),

                    tags$div(class = "plot-row-4 plot-col-1", "genetic div"),
                    tags$div(class = "plot-row-4 plot-col-2", checkboxInput("geneDistCheck", label = "")),
                    tags$div(class = "plot-row-4 plot-col-3", checkboxInput("geneTimeCheck", label = "")),

                    bsTooltip("abundDistCheck", "Display the abundance distribution plot", placement = "bottom", trigger = "hover"),
                    bsTooltip("abundTimeCheck", "Display the abundance time plot", placement = "bottom", trigger = "hover"),
                    bsTooltip("abundDistCheck", "Display the trait distribution plot", placement = "bottom", trigger = "hover"),
                    bsTooltip("traitTimeCheck", "Display the trait time plot", placement = "bottom", trigger = "hover"),
                    bsTooltip("geneDistCheck", "Display the genetic diversity distribution plot", placement = "bottom", trigger = "hover"),
                    bsTooltip("geneTimeCheck", "Display the genetic diversity time plot", placement = "bottom", trigger = "hover"),
                )
            ),

            tags$div(
                class = "control-set",

                h3("Downloads"),
                tags$div(
                    class = "down-group",
                    tags$div(
                        class = "down-link",
                        actionLink("downSim", "click to download simulation")),
                    tags$div(
                        class = "down-link",
                        actionLink("downScript", "click to download script")),
                    tags$div(
                        class = "down-link",
                        actionLink("downPlots", "click to download plots"))
                )
            )
        ),

        mainPanel(
            h1("Rules of Life Engine model"),

            fluidRow(
                conditionalPanel(
                    "input.abundDistCheck",
                    class = "cond-panel",
                    column(5, plotlyOutput("abundDist"))
                ),
                conditionalPanel(
                    "input.abundTimeCheck",
                    class = "cond-panel",
                    column(7, plotlyOutput("abundTime"))
                )
            ),

            fluidRow(
                conditionalPanel(
                    "input.traitDistCheck",
                    class = "cond-panel",
                    column(5, plotlyOutput("traitDist"))
                ),
                conditionalPanel(
                    "input.traitTimeCheck",
                    class = "cond-panel",
                    column(7, plotlyOutput("traitTime"))
                )
            ),

            fluidRow(
                conditionalPanel(
                    "input.geneDistCheck",
                    class = "cond-panel",
                    column(5, plotlyOutput("geneDist")),
                ),
                conditionalPanel(
                    "input.geneTimeCheck",
                    class = "cond-panel",
                    column(7, plotlyOutput("geneTime")),
                )
            )

        )
    )
)

shinyApp(ui, server)
