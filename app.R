# Load Shiny
library(shiny)

# Source Sidebar and Graph Modules
source("R/mod_roleNeutral.R")

# Define UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .param-row {
        display: flex;
        align-items: center;
        width: 100%;
        margin-bottom: 10px;
        margin-left: 0 !important;
        padding-left: 0 !important;
      }

      .param-row .form-group {
        margin-left: 0 !important;
        padding-left: 0 !important;
      }

      .param-label {
        font-weight: bold;
        margin-right: 5px;
        white-space: nowrap;
        min-width: 25px;
        max-width: 25px;
        text-align: right;
      }

      .param-inputs {
        display: flex;
        align-items: center;
        gap: 5px;
        flex-grow: 1;
      }

      .param-inputs input[type='number'] {
        width: 80px;
      }

      .param-inputs .irs {
        width: 100%;
      }

      .form-group {
        margin-bottom: 0;
      }
    "))
  ),
  
  navbarPage(
    title = div(
      tags$img(src = "imgs/ROLE-logo.png", height = "40px", style = "margin-top: -10px; margin-right: 10px;"),
    ),
    tabPanel(
      "Neutral",
      mod_roleNeutral_ui("roleNeutral_1")  # returns sidebarLayout now
    )
    # mod_roleLV_ui("roleLV_1"),
    # mod_roleCoexistence_ui("roleCoexistence_1"),
    # mod_roleMESS_ui("roleMESS_1")
  )
)

# Define Server
server <- function(input, output, session) {
  mod_roleNeutral_server("roleNeutral_1")
  mod_roleLV_server("roleLV_1")
  mod_roleCoexistence_server("roleCoexistence_1")
  mod_roleMESS_server("roleMESS_1")
}

# Run the App
shinyApp(ui = ui, server = server)
