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
      numericInput(ns(name), label = NULL, min = min, max = max, 
                   value = value, width = 90),
      shinyBS::bsTooltip(ns(name), tip)
    )
  )
}


### max and default values for all role Params. Easy place to adjust

### Common params ###
max_sm <- 1000
value_sm <- 100

max_jm <- 10000
value_jm <- 2500

max_j <- 1000
value_j <- 100

max_m <- 1.0
value_m <- 0.1

max_nu <- 1.0
value_nu <- 0.01


max_steps <- 1000
value_steps <- 500

### Filter params ###
max_filt_mean <- 1.0
value_filt_mean <- 0.5

max_filt_sd <- 1.0
value_filt_sd <- 0.1

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
                                 tip = "Number of species in the metacommunity"),
                       
                       roleParamText(id, name = "sm_t", label = NULL, 
                                     min = 0, max = max_sm, value = value_sm),
                       
                       roleParam(id, name = "jm", label = "J<sub>m</sub>",
                                 min =  0, max = max_jm, value = value_jm,
                                 tip = "Number of individuals in the metacommunity"),
                       
                       roleParamText(id, name = "jm_t", label = NULL, 
                                     min = 0, max = max_jm, value = value_jm),
                       
                       roleParam(id, name = "j", label = "J",
                                 min = 0, max = max_j, value = value_j,
                                 tip = "Number of individuals in the local community"),
                       
                       roleParamText(id, name = "j_t", label = NULL, 
                                     min = 0, max = max_j, value = value_j),
                       
                       roleParam(id, name = "m", label = "m",
                                 min = 0, max = max_m, value = value_m,
                                 tip = "Probability of migration into the local community"),
                       
                       roleParamText(id, name = "m_t", label = NULL, 
                                     min = 0, max = max_m, value = value_m),
                       
                       # roleParam(id, name = "nu", label = "&#957;",
                       #           min = 0, max = max_nu, value = value_nu,
                       #           tip = "The speciation local parameter",
                       #           isGreek = TRUE),
                       # 
                       # roleParamText(id, name = "nu_t", label = NULL, 
                       #               min = 0, max = max_nu, value = value_nu),
                       
                       roleParam(id, name = "nstep", label = "n<sub>step</sub>",
                                 min = 1, max = max_steps, value = value_steps,
                                 tip = "The number of time steps to run"),
                       
                       roleParamText(id, name = "nstep_t", label = NULL, 
                                     min = 0, max = max_steps, value = value_steps),
                     ),
    ),
    
    shinyBS::bsButton("filterParams", label = "Filtering Parameters", type = "toggle", class = "show-hide"),
    shinyBS::bsTooltip("filterParams", "Show/hide environmental filtering parameters", placement = "bottom", trigger = "hover"),
    
    conditionalPanel("input.filterParams", class = "cond-panel",
                     
                     div(
                       class = "param-group param-2",
                       
                       radioGroupButtons(
                         inputId = ns("env_filt"),
                         label = "Type of Environmental Filtering", 
                         choices = c("None", "Stabilizing", "Disruptive"),
                         status = "primary",
                         selected = "None",
                         size = "sm",
                         justified = FALSE
                       ),
                       
                       roleParam(id, name = "filt_mean", label = "M",
                                 min = 0, max = max_filt_mean, value = value_filt_mean,
                                 tip = "Mean trait value for stabilizing filtering"),
                       
                       roleParamText(id, name = "filt_mean_t", label = NULL, 
                                     min = 0, max = max_filt_mean, value = value_filt_mean),
                       
                       roleParam(id, name = "filt_sd", label = "SD",
                                 min = 0, max = max_filt_sd, value = value_filt_sd,
                                 tip = "Standard deviation of stabilizing filtering"),
                       
                       roleParamText(id, name = "filt_sd_t", label = NULL, 
                                     min = 0, max = max_filt_sd, value = value_filt_sd),
                       
            
                       
                     ),
    ),
    
    # shinyBS::bsButton("compParams", label = "Competition Parameters", type = "toggle", class = "show-hide"),
    # shinyBS::bsTooltip("compParams", "Show/hide competition parameters", placement = "bottom", trigger = "hover"),
    # 
    # conditionalPanel("input.compParams", class = "cond-panel",
    #                  
    #                  div(
    #                    class = "param-group param-3",
    #                    
    #                    checkboxInput(ns("compChk"), label = "Competition?"),
    #                    
    #                    roleParam(id, name = "nout", label = "n<sub>out</sub>",
    #                              min = 1, max = 100, value = 10,
    #                              tip = "Plot every n steps of the simulation"),
    #                    
    #                    roleParam(id, name = "nvis", label = "n<sub>vis</sub>",
    #                              min = 1, max = 100, value = 2,
    #                              tip = "Update the plots every nvis * nout"),
    #                    
    #                  ),
    # ),
    # 
    shinyBS::bsButton("plotParams", label = "Plot tools", type = "toggle", class = "show-hide"),
    shinyBS::bsTooltip("plotParams", "Show/hide tools to customize plots", placement = "bottom", trigger = "hover"),
    
    conditionalPanel("input.plotParams", class = "cond-panel",
                     
                     div(
                       class = "param-group param-4",
                       
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
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # observe() calls to make the numeric input responsive to slider input and vice-versa
    # Unfortunately, I can't wrap the observe() calls in a function to make this more succinct 
    
    ########################
    ##### Common params ####
    ########################
    
    ########################
    ########################
    
    ## update the Sm slider. 
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
    
    ########################
    ########################
    
    ## update the Jm slider. 
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
    
    ########################
    ########################
    
    ## update the J slider. 
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
    
    ########################
    ########################
    
    ## update the m slider. 
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
    
    ########################
    ########################
    
    ## update the m slider. 
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
    
    ########################
    ########################
    
    ## update the nu slider. 
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
    
    ########################
    ########################
    
    ## update the nstep slider. 
    observe(
      updateNumericInput(session,
                         inputId = "nstep_t",
                         value = input$nstep)
    ) %>%
      bindEvent(input$nstep)
    
    observe(
      updateSliderInput(session,
                        "nstep",
                        value = input$nstep_t)
    ) %>%
      bindEvent(input$nstep_t)
    
    
    ########################
    ##### Filter params ####
    ########################
    
    ## update the filt_mean slider. 
    observe(
      updateNumericInput(session,
                         inputId = "filt_mean_t",
                         value = input$filt_mean)
    ) %>%
      bindEvent(input$filt_mean)
    
    observe(
      updateSliderInput(session,
                        "filt_mean",
                        value = input$filt_mean_t)
    ) %>%
      bindEvent(input$filt_mean_t)
    
    # update the filt_sd slider. 
    observe(
      updateNumericInput(session,
                         inputId = "filt_sd_t",
                         value = input$filt_sd)
    ) %>%
      bindEvent(input$filt_sd)
    
    observe(
      updateSliderInput(session,
                        "filt_sd",
                        value = input$filt_sd_t)
    ) %>%
      bindEvent(input$filt_sd_t)
    
  })
  
}
    
## To be copied in the UI
# mod_roleParams_ui("roleParams_ui_1")
    
## To be copied in the server
# mod_roleParams_server("roleParams_ui_1")
