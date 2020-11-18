library(shiny)
library(shinyBS)

source("R/util.R")
source("R/roleAppState.R")


roleParam <- function(id, name, label = "", min = 0, max = 100000, value = 100, tip = "", isGreek = FALSE) {
    ns <- NS(id)
    opener = if (isGreek) '<div class="param-label greek">' else '<div class="param-label">'
    tagList(
        HTML(paste(opener, label, "</div>")),
        tags$div(
            class = "param-wrapper",
            sliderInput(ns(name), label = "", min = min, max = max, value = value, ticks = FALSE),
            bsTooltip(ns(name), tip)
        )
    )
}


roleParamsUI <- function(id, button) {
    ns <- NS(id)

    tags$div(
        class = "control-set",
        h3("Parameters"),

        tags$div(class = "show-hide", bsButton("commonParams", label = "Common Parameters", type = "toggle", value = TRUE)),
        bsTooltip("commonParams", "Show/hide common parameters", placement = "bottom", trigger = "hover"),

        conditionalPanel("input.commonParams", class = "cond-panel",

            tags$div(
                class = "param-group",

                roleParam(id, name = "sm", label = "S<sub>m",
                          min = 0, max = 10000, value = 100,
                          tip = "The species metaparameter"),

                roleParam(id, name = "jm", label = "J<sub>m",
                          min =  0, max = 100000, value = 10000,
                          tip = "The individuals metaparameter"),

                roleParam(id, name = "j", label = "J",
                          min = 0, max = 100000, value = 100,
                          tip = "The individuals local parameter"),

                roleParam(id, name = "m", label = "m",
                          min = 0, max = 1.0, value = 0.1,
                          tip = "The dispersal probability"),

                roleParam(id, name = "nu", label = "&#957;",
                          min = 0, max = 1.0, value = 0.01,
                          tip = "The speciation local parameter",
                          isGreek = TRUE)
            ),
        ),

        tags$div(class = "show-hide", bsButton("extraParams", label = "Extra Parameters", type = "toggle")),
        bsTooltip("extraParams", "Show/hide extra parameters", placement = "bottom", trigger = "hover"),

        conditionalPanel("input.extraParams", class = "cond-panel",

            tags$div(
                class = "param-group param-2",

                roleParam(id, name = "nstep",
                          label = "n<sub>step</sub>",
                          min = 1, max = 100, value = 10,
                          tip = "The number of steps"),

                roleParam(id, name = "nsim", label = "n<sub>sim</sub>",
                          min = 1, max = 20, value = 1,
                          tip = "The number of simulations to run"),
            ),
        ),
    )
}


roleParamsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$sm, {pause()}, ignoreInit = TRUE)
        observeEvent(input$jm, {pause()}, ignoreInit = TRUE)
        observeEvent(input$j, {pause()}, ignoreInit = TRUE)
        observeEvent(input$m, {pause()}, ignoreInit = TRUE)
        observeEvent(input$nu, {pause()}, ignoreInit = TRUE)
        observeEvent(input$nstep, {pause()}, ignoreInit = TRUE)
        observeEvent(input$nsim, {pause()}, ignoreInit = TRUE)
    })
}
