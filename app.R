# Load Shiny
library(shiny)

# Source Sidebar and Graph Modules
source("R/mod_roleNeutral.R")

# Define UI
ui <- fluidPage(
  navbarPage(
    tags$img(src="imgs/ROLE-logo.png", height="50px", style="margin-top: -10px;"),
    mod_roleNeutral_ui("roleNeutral_1")
  )
)

# Define Server
server <- function(input, output, session) {
  mod_roleNeutral_server("roleNeutral_1")
}

# Run the App
shinyApp(ui = ui, server = server)
