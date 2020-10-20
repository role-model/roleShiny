library(shiny)
library(ggplot2)
library(plotly)

ui <- fluidPage(
    theme = "ui.css",

    sidebarLayout(

        sidebarPanel(

            tags$div(
                class = "control-set",
                h3("Parameters"),

                tags$div(
                    class = "param-group",

                    HTML('<div class="param-label">S<sub>m</sub></div>'),
                    tags$div(
                        class = "param-wrapper",
                        sliderInput("sm", label = "", min = 0, max = 100, value = 20, ticks = FALSE)
                    ),

                    HTML('<div class="param-label">J<sub>m</sub></div>'),
                    tags$div(
                        class = "param-wrapper",
                        sliderInput("jm", label = "", min = 0, max = 100, value = 30, ticks = FALSE)
                    ),

                    tags$div(class = "param-label", "J"),
                    tags$div(
                        class = "param-wrapper",
                        sliderInput("j", label = "", min = 0, max = 100, value = 50, ticks = FALSE)
                    ),

                    tags$div(class = "param-label", "m"),
                    tags$div(
                        class = "param-wrapper",
                        sliderInput("m", label = "", min = 0, max = 100, value = 10, ticks = FALSE)
                    ),

                    HTML('<div class="param-label greek">&#957;</div>'),
                    tags$div(
                        class = "param-wrapper",
                        sliderInput("nu", label = "", min = 0, max = 100, value = 80, ticks = FALSE)
                    )
                )
            ),

            tags$div(
                class = "control-set but-group",
                actionButton("play", label = "\u23F5"),
                actionButton("pause", label = "\u23F8"),
                actionButton("rewind", label = "\u27f2")
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
                    tags$div(class = "plot-row-4 plot-col-3", checkboxInput("geneTimeCheck", label = ""))
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
                    "input.abundDistCheck == true",
                    column(5, plotlyOutput("abundDist"))
                ),
                conditionalPanel(
                    "input.abundTimeCheck == true",
                    column(7, plotlyOutput("abundTime"))
                )
            ),

            fluidRow(
                conditionalPanel(
                    "input.traitDistCheck == true",
                    column(5, plotlyOutput("traitDist"))
                ),
                conditionalPanel(
                    "input.traitTimeCheck == true",
                    column(7, plotlyOutput("traitTime"))
                )
            ),

            fluidRow(
                conditionalPanel(
                    "input.geneDistCheck == true",
                    column(5, plotlyOutput("geneDist")),
                ),
                conditionalPanel(
                    "input.geneTimeCheck == true",
                    column(7, plotlyOutput("geneTime")),
                )
            )

        )
    )
)
