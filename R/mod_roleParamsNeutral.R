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

# slider input
roleParam <- function(id, name, label = "", min = 0, max = 100000, value = 100, tip = "", isGreek = FALSE) {
  ns <- NS(id)
  opener = if (isGreek) '<div class="param-label greek">' else '<div class="param-label">'
  tagList(
    HTML(paste(opener, label, "</div>")),
    div(
      class = "param-wrapper",
      sliderInput(ns(name), label = "", min = min, max = max, value = value, ticks = FALSE),
      shinyBS::bsTooltip(ns(name), tip)
    )
  )
}

# corresponding text input
roleParamText <- function(id, name, label = "", min = 0, max = 100000, value = 100, tip = "", isGreek = FALSE) {
  ns <- NS(id)
  tagList(
    div(
      numericInput(ns(name), label = NULL, min = min, max = max, 
                   value = value, width = 90),
      shinyBS::bsTooltip(ns(name), tip)
    )
  )
}


### max and default values for all role Params. Easy place to adjust

### Common params ###

max_jm <- 10000
value_jm <- 1000

max_j <- 1000
value_j <- 100

max_sm <- 2000
value_sm <- 500

max_nu <- 1.0
value_nu <- 0.1

max_num <- 1.0
value_num <- 0.1

max_ext <- 1.0
value_ext <- 0.1

max_m <- 1.0
value_m <- 0.1

max_eq <- 1.0
value_eq <- 0.5

#### genetics params ####
max_mu <- 0.01
value_mu <- 0.001

max_bp <- 1000
value_bp <- 500

#### simulation length params ####
max_iter <- 100
value_iter <- 10

mod_roleParamsNeutral_ui <- function(id, button) {
  ns <- NS(id)
  
  div(
    h2("Parameters"),
    
    div(
      roleParam(
        id,
        name = "j",
        label = "J",
        min = 0,
        max = max_j,
        value = value_j,
        tip = "Number of individuals in the local community"
      ),
      
      roleParamText(
        id,
        name = "j_t",
        label = NULL,
        min = 0,
        max = max_j,
        value = value_j
      ),
      
      roleParam(
        id,
        name = "jm",
        label = "J<sub>m</sub>",
        min =  0,
        max = max_jm,
        value = value_jm,
        tip = "Number of individuals in the metacommunity"
      ),
      
      roleParamText(
        id,
        name = "jm_t",
        label = NULL,
        min = 0,
        max = max_jm,
        value = value_jm
      ),
      
      roleParam(
        id,
        name = "sm",
        label = "S<sub>m</sub>",
        min = 0,
        max = max_sm,
        value = value_sm,
        tip = "Number of species in the metacommunity"
      ),
      
      roleParamText(
        id,
        name = "sm_t",
        label = NULL,
        min = 0,
        max = max_sm,
        value = value_sm
      ),
      
      roleParam(
        id,
        name = "nu",
        label = "&#957;",
        min = 0,
        max = max_nu,
        value = value_nu,
        tip = "The probability of local speciation",
        isGreek = TRUE
      ),
      
      roleParamText(
        id,
        name = "nu_t",
        label = NULL,
        min = 0,
        max = max_nu,
        value = value_nu
      ),
      
      roleParam(
        id,
        name = "num",
        label = "&#957;<sub>m</sub>",
        min = 0,
        max = max_nu,
        value = value_nu,
        tip = "The speciation rate in the meta community",
        isGreek = TRUE
      ),
      
      roleParamText(
        id,
        name = "num_t",
        label = NULL,
        min = 0,
        max = max_nu,
        value = value_nu
      ),
      
      roleParam(
        id,
        name = "ext",
        label = "E",
        min = 0,
        max = max_ext,
        value = value_ext,
        tip = "Extinction rate in the meta community"
      ),
      
      roleParamText(
        id,
        name = "ext_t",
        label = NULL,
        min = 0,
        max = max_ext,
        value = value_ext
      ),
      
      
      roleParam(
        id,
        name = "m",
        label = "m",
        min = 0,
        max = max_m,
        value = value_m,
        tip = "The local dispersal probability"
      ),
      
      roleParamText(
        id,
        name = "m_t",
        label = NULL,
        min = 0,
        max = max_m,
        value = value_m
      ),
      
      roleParam(
        id,
        name = "eq",
        label = "EQ",
        min = 0,
        max = max_eq,
        value = value_eq,
        tip = "The proportion of equilibrium achieved"
      ),
      
      roleParamText(
        id,
        name = "eq_t",
        label = NULL,
        min = 0,
        max = max_eq,
        value = value_eq
      ),
      
      roleParamDrop(
        id,
        name = "type",
        label = "Type",
        tip = "Initialization routine"
      ),
      
      #### genetics parameters ####
      roleParam(
        id,
        name = "mu",
        label = "&#956;",
        min = 0,
        max = max_mu,
        value = value_mu,
        tip = "Mutation rate"
      ),
      
      roleParamText(
        id,
        name = "mu_t",
        label = NULL,
        min = 0,
        max = max_mu,
        value = value_mu
      ),
      
      roleParam(
        id,
        name = "bp",
        label = "BP",
        min = 100,
        max = max_bp,
        value = value_bp,
        tip = "The number of basepairs"
      ),
      
      roleParamText(
        id,
        name = "bp_t",
        label = NULL,
        min = 100,
        max = max_bp,
        value = value_bp
      ),
      
      #### simulation length parameters ####
      roleParam(
        id,
        name = "iter",
        label = "n<sub>iter</sub>",
        min = 1,
        max = max_iter,
        value = value_iter,
        tip = "The number of iterations to run"
      ),
      
      roleParamText(
        id,
        name = "iter_t",
        label = NULL,
        min = 1,
        max = max_iter,
        value = value_iter
      )
      
    )
  )
}
    
#' roleParams Server Functions
#'
#' @noRd 
mod_roleParamsNeutral_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # observe() calls to make the numeric input responsive to slider input and vice-versa
    # Unfortunately, I can't wrap the observe() calls in a function to make this more succinct
    
    ##### Common params ####
    
    #### Jm slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "jm_t",
                         value = input$jm)
    ) %>%
      bindEvent(input$jm)
    
    observe(
      updateSliderInput(session,
                        "jm",
                        value = input$jm_t)
    ) %>%
      bindEvent(input$jm_t)
    
    #### J slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "j_t",
                         value = input$j)
    ) %>%
      bindEvent(input$j)
    
    observe(
      updateSliderInput(session,
                        "j",
                        value = input$j_t)
    ) %>%
      bindEvent(input$j_t)
    
    #### Sm slider ####
    observe(
      updateNumericInput(session,
                         inputId = "sm_t",
                         value = input$sm)
    ) %>%
      bindEvent(input$sm)
    
    observe(
      updateSliderInput(session,
                        "sm",
                        value = input$sm_t)
    ) %>%
      bindEvent(input$sm_t)
    
    #### nu slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "nu_t",
                         value = input$nu)
    ) %>%
      bindEvent(input$nu)
    
    observe(
      updateSliderInput(session,
                        "nu",
                        value = input$nu_t)
    ) %>%
      bindEvent(input$nu_t)
    
    #### num slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "num_t",
                         value = input$num)
    ) %>%
      bindEvent(input$num)
    
    observe(
      updateSliderInput(session,
                        "num",
                        value = input$num_t)
    ) %>%
      bindEvent(input$num_t)
    
    #### ext slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "ext_t",
                         value = input$ext)
    ) %>%
      bindEvent(input$ext)
    
    observe(
      updateSliderInput(session,
                        "ext",
                        value = input$ext_t)
    ) %>%
      bindEvent(input$ext_t)
    
    #### m slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "m_t",
                         value = input$m)
    ) %>%
      bindEvent(input$m)
    
    observe(
      updateSliderInput(session,
                        "m",
                        value = input$m_t)
    ) %>%
      bindEvent(input$m_t)
    
    #### eq slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "eq_t",
                         value = input$eq)
    ) %>%
      bindEvent(input$eq)
    
    observe(
      updateSliderInput(session,
                        "eq",
                        value = input$eq_t)
    ) %>%
      bindEvent(input$eq_t)
    
    #### Genetics params ####
    
    #### mu slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "mu_t",
                         value = input$mu)
    ) %>%
      bindEvent(input$mu)
    
    observe(
      updateSliderInput(session,
                        "mu",
                        value = input$mu_t)
    ) %>%
      bindEvent(input$mu_t)
    
    #### bp slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "bp_t",
                         value = input$bp)
    ) %>%
      bindEvent(input$bp)
    
    observe(
      updateSliderInput(session,
                        "bp",
                        value = input$bp_t)
    ) %>%
      bindEvent(input$bp_t)
    #### Sim length params ####
    
    #### iter slider ####
    
    observe(
      updateNumericInput(session,
                         inputId = "iter_t",
                         value = input$iter)
    ) %>%
      bindEvent(input$iter)
    
    observe(
      updateSliderInput(session,
                        "iter",
                        value = input$iter_t)
    ) %>%
      bindEvent(input$iter_t)
    
    
  })
  
}

## To be copied in the UI
# mod_roleParams_ui("roleParams_ui_1")

## To be copied in the server
# mod_roleParams_server("roleParams_ui_1")
