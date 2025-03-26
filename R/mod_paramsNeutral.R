#' roleParams UI Function
#'
#' @description A shiny Module controlling parameter inputs for simulations
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import shiny
#' @importFrom shinyBS bsTooltip bsButton

roleParamRow <- function(id, name, label = "", min = 0, max = 100000, value = 100, tip = "", isGreek = FALSE) {
  ns <- NS(id)
  opener <- if (isGreek) '<div class="param-label greek">' else '<div class="param-label">'
  
  div(
    class = "form-inline",  # ← prevents form layout from inserting spacing
    div(
      class = "param-row",
      HTML(paste0(opener, label, "</div>")),
      div(class = "param-inputs",
          numericInput(ns(paste0(name, "_t")), label = NULL, min = min, max = max, value = value, width = "80px"),
          sliderInput(ns(name), label = NULL, min = min, max = max, value = value, ticks = FALSE, width = "100%")
      ),
      shinyBS::bsTooltip(ns(name), tip),
      shinyBS::bsTooltip(ns(paste0(name, "_t")), tip)
    )
  )
}

roleParamDrop <- function(id, name, label = NULL, selected = "oceanic_island", tip = "") {
  ns <- NS(id)
  tagList(div(
    selectInput(
      ns(name),
      label = label,
      choices = c("oceanic_island", "bridge_island"),
      selected = selected
    ),
    shinyBS::bsTooltip(ns(name), tip)
  ))
}

# Parameter defaults
max_jm <- 10000; value_jm <- 1000
max_j <- 1000; value_j <- 100
max_sm <- 1000; value_sm <- 100
max_nu <- 0.5;  value_nu <- 0.01
max_m <- 1.0;  value_m <- 0.2
max_iter <- 10000; value_iter <- 1000

mod_roleParamsNeutral_ui <- function(id, button) {
  ns <- NS(id)
  
  tagList(
    h2("Parameters", style = "margin-top: 0; margin-bottom: 15px;"),
    roleParamDrop(id, "type", "Initialization Type", tip = "Initialization routine"),
    h1("", style = "margin-top: 0; margin-bottom: 15px;"),
    roleParamRow(id, "jm", "J<sub>m</sub>", 0, max_jm, value_jm, "Number of individuals in the metacommunity"),
    roleParamRow(id, "sm", "S<sub>m</sub>", 0, max_sm, value_sm, "Number of species in the metacommunity"),
    roleParamRow(id, "j", "J",     0, max_j, value_j, "Number of individuals in the local community"),
    roleParamRow(id, "nu", "&#957;",   0, max_nu, value_nu, "The probability of local speciation", isGreek = TRUE),
    roleParamRow(id, "m", "m",     0, max_m, value_m, "The local dispersal probability"),
    roleParamRow(id, "iter", "n<sub>iter</sub>", 1, max_iter, value_iter, "The number of iterations to run")
  )
}

#' roleParams Server Functions
#'
#' @noRd
mod_roleParamsNeutral_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Sync sliders and numeric inputs
    observe(updateNumericInput(session, "jm_t", value = input$jm)) %>% bindEvent(input$jm)
    observe(updateSliderInput(session, "jm", value = input$jm_t)) %>% bindEvent(input$jm_t)
    
    observe(updateNumericInput(session, "j_t", value = input$j)) %>% bindEvent(input$j)
    observe(updateSliderInput(session, "j", value = input$j_t)) %>% bindEvent(input$j_t)
    
    observe(updateNumericInput(session, "sm_t", value = input$sm)) %>% bindEvent(input$sm)
    observe(updateSliderInput(session, "sm", value = input$sm_t)) %>% bindEvent(input$sm_t)
    
    observe(updateNumericInput(session, "nu_t", value = input$nu)) %>% bindEvent(input$nu)
    observe(updateSliderInput(session, "nu", value = input$nu_t)) %>% bindEvent(input$nu_t)
    
    observe(updateNumericInput(session, "m_t", value = input$m)) %>% bindEvent(input$m)
    observe(updateSliderInput(session, "m", value = input$m_t)) %>% bindEvent(input$m_t)
    
    observe(updateNumericInput(session, "iter_t", value = input$iter)) %>% bindEvent(input$iter)
    observe(updateSliderInput(session, "iter", value = input$iter_t)) %>% bindEvent(input$iter_t)
  })
}
