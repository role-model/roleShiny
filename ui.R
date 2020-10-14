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
            sliderInput(inputId = "sm", label = "", min = 0, max = 100, value = 20, ticks = FALSE)
          ),

          HTML('<div class="param-label">J<sub>m</sub></div>'),
          tags$div(
            class = "param-wrapper",
            sliderInput(inputId = "jm", label = "", min = 0, max = 100, value = 30, ticks = FALSE)
          ),

          tags$div(class = "param-label", "J"),
          tags$div(
            class = "param-wrapper",
            sliderInput(inputId = "j", label = "", min = 0, max = 100, value = 50, ticks = FALSE)
          ),

          tags$div(class = "param-label", "m"),
          tags$div(
            class = "param-wrapper",
            sliderInput(inputId = "m", label = "", min = 0, max = 100, value = 10, ticks = FALSE)
          ),

          HTML('<div class="param-label greek">&#957;</div>'),
          tags$div(
            class = "param-wrapper",
            sliderInput(inputId = "nu", label = "", min = 0, max = 100, value = 80, ticks = FALSE)
          )
        )
      ),
      tags$div(
        class = "control-set but-group",
        actionButton(inputId = "play", label = "\u23F5"),
        actionButton(inputId = "pause", label = "\u23F8"),
        actionButton(inputId = "rewind", label = "\u27f2")
      ),
      tags$div(
        class = "control-set",

        h3("Plots"),
        tags$div(
          class = "plot-group",
          HTML('<div class="plot-row-1 plot-col-2">distri&shy;bution</div>'),
          tags$div(class = "plot-row-1 plot-col-3", "time series"),

          tags$div(class = "plot-row-2 plot-col-1", "abundance"),
          tags$div(class = "plot-row-2 plot-col-2", checkboxInput(inputId = "abundDist", label = "")),
          tags$div(class = "plot-row-2 plot-col-3", checkboxInput(inputId = "abundTime", label = "")),

          tags$div(class = "plot-row-3 plot-col-1", "traits"),
          tags$div(class = "plot-row-3 plot-col-2", checkboxInput(inputId = "traitDist", label = "")),
          tags$div(class = "plot-row-3 plot-col-3", checkboxInput(inputId = "traitTime", label = "")),

          tags$div(class = "plot-row-4 plot-col-1", "genetic div"),
          tags$div(class = "plot-row-4 plot-col-2", checkboxInput(inputId = "geneDist", label = "")),
          tags$div(class = "plot-row-4 plot-col-3", checkboxInput(inputId = "geneTime", label = ""))
        )
      ),
      tags$div(
        class = "control-set",

        h3("Downloads"),
        tags$div(
          class = "down-group",
          tags$div(
            class = "down-link",
            actionLink(inputId = "downSim", "click to download simulation")),
          tags$div(
            class = "down-link",
            actionLink(inputId = "downScript", "click to download script")),
          tags$div(
            class = "down-link",
            actionLink(inputId = "downPlots", "click to download plots"))
        )
      )
    ),
    mainPanel(
      h1("Rules of Life Engine model"),
      fluidRow(
        conditionalPanel(
          "input.abundDist == true",
          column(5, plotOutput(outputId = "abundDist"))
        ),
        conditionalPanel(
          "input.abundTime == true",
          column(7, plotOutput(outputId = "abundTime"))
        )
      ),
      fluidRow(
        conditionalPanel(
          "input.traitDist == true",
          column(5, plotOutput(outputId = "traitDist"))
        ),
        conditionalPanel(
          "input.traitTime == true",
          column(7, plotOutput(outputId = "traitTime"))
        )
      ),
      fluidRow(
        conditionalPanel(
          "input.geneDist == true",
          column(5, plotOutput(outputId = "geneDist")),
        ),
        conditionalPanel(
          "input.geneTime == true",
          column(7, plotOutput(outputId = "geneTime")),
        )
     )
    )
  )
)
