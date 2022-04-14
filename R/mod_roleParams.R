#' roleParams UI Function
#'
#' @description A shiny Module controlling parameter inputs for simulations
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
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
  opener = if (isGreek) '<div class="param-label greek">' else '<div class="param-label">'
  tagList(
    HTML(paste(opener, label, "</div>")),
    div(
      class = "param-wrapper",
      textInput(ns(name), label = NULL, min = min, max = max, value = value),
      shinyBS::bsTooltip(ns(name), tip)
    )
  )
}


### max and default values for all role Params. Easy place to adjust
max_sm <- 10000
value_sm <- 100

max_jm <- 100000
value_jm <- 25000

max_j <- 10000
value_j <- 1000

max_m <- 1.0
value_m <- 0.1

max_nu <- 1.0
value_nu <- 0.01


max_steps <- 1000
value_steps <- 500


mod_roleParams_ui <- function(id, button){
  ns <- NS(id)
  
  div(
    class = "control-set",
    h3("Parameters"),
    
    shinyBS::bsButton("commonParams", label = "Common Parameters", type = "toggle", value = TRUE, class = "show-hide"),
    shinyBS::bsTooltip("commonParams", "Show/hide common parameters", placement = "bottom", trigger = "hover"),
    
    conditionalPanel("input.commonParams", class = "cond-panel",
                     
                     div(
                       class = "param-group",
                       
                       roleParam(id, name = "sm", label = "S<sub>m</sub>",
                                 min = 0, max = max_sm, value = value_sm,
                                 tip = "The species metaparameter"),
                       
                       roleParam(id, name = "jm", label = "J<sub>m</sub>",
                                 min =  0, max = max_jm, value = value_jm,
                                 tip = "The individuals metaparameter"),
                       
                       roleParam(id, name = "j", label = "J",
                                 min = 0, max = max_j, value = value_j,
                                 tip = "The individuals local parameter"),
                       
                       roleParam(id, name = "m", label = "m",
                                 min = 0, max = max_m, value = value_m,
                                 tip = "The dispersal probability"),
                       
                       roleParam(id, name = "nu", label = "&#957;",
                                 min = 0, max = max_nu, value = value_nu,
                                 tip = "The speciation local parameter",
                                 isGreek = TRUE),
                    
                       
                       roleParam(id, name = "nstep", label = "n<sub>step</sub>",
                                 min = 1, max = max_steps, value = value_steps,
                                 tip = "The number of time steps to run"),
                     ),
    ),
    
    shinyBS::bsButton("extraParams", label = "Extra Parameters", type = "toggle", class = "show-hide"),
    shinyBS::bsTooltip("extraParams", "Show/hide extra parameters", placement = "bottom", trigger = "hover"),
    
    conditionalPanel("input.extraParams", class = "cond-panel",
                     
                     div(
                       class = "param-group param-2",
                       
                       roleParam(id, name = "nout", label = "n<sub>out</sub>",
                                 min = 1, max = 100, value = 10,
                                 tip = "Plot every n steps of the simulation"),
                       
                       roleParam(id, name = "nvis", label = "n<sub>vis</sub>",
                                 min = 1, max = 100, value = 2,
                                 tip = "Update the plots every nvis * nout"),
                       
                     ),
    ),
  )
}
    
#' roleParams Server Functions
#'
#' @noRd 
mod_roleParams_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_roleParams_ui("roleParams_ui_1")
    
## To be copied in the server
# mod_roleParams_server("roleParams_ui_1")
