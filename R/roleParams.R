library(shiny)
library(shinyBS)


source("R/util.R")
source("R/roleParam.R")


roleParamsUI <- function(id) {
    ns <- NS(id)

    tags$div(
        class = "control-set",
        h3("Parameters"),

        tags$div(class = "show-hide", bsButton("commonParams", label = "Common Parameters", type = "toggle", value = TRUE)),
        bsTooltip("commonParams", "Show/hide common parameters", placement = "bottom", trigger = "hover"),

        conditionalPanel(
            "input.commonParams",
            class = "cond-panel",

            tags$div(
                class = "param-group",

                roleParamUI(
                    "sm",
                    label = "S<sub>m",
                    min = 0,
                    max = 10000,
                    value = 100,
                    tip = "The species metaparameter"),
                roleParamUI(
                    "jm",
                    label = "J<sub>m",
                    min =  0,
                    max = 100000,
                    value = 10000,
                    tip = "The individuals metaparameter"),
                roleParamUI(
                    "j",
                    label = "J",
                    min = 0,
                    max = 100000,
                    value = 100,
                    tip = "The individuals local parameter"),
                roleParamUI(
                    "m",
                    label = "m",
                    min = 0,
                    max = 1.0,
                    value = 0.1,
                    tip = "The dispersal probability"),
                roleParamUI(
                    "nu",
                    label = "&#957;",
                    min = 0,
                    max = 1.0,
                    value = 0.01,
                    tip = "The speciation local parameter",
                    isGreek = TRUE),
            ),
        ),

        tags$div(class = "show-hide", bsButton("extraParams", label = "Extra Parameters", type = "toggle")),
        bsTooltip("extraParams", "Show/hide extra parameters", placement = "bottom", trigger = "hover"),

        conditionalPanel(
            "input.extraParams",
            class = "cond-panel",

            tags$div(
                class = "param-group param-2",

                roleParamUI(
                    "nstep",
                    label = "n<sub>step</sub>",
                    min = 1,
                    max = 100,
                    value = 10,
                    tip = "The number of steps"),
                roleParamUI(
                    "nsim",
                    label = "n<sub>sim</sub>",
                    min = 1,
                    max = 20,
                    value = 1,
                    tip = "The number of simulations to run"),
            ),
        ),
    )
}


roleParamsServer <- function(id) {
    moduleServer(id, function(input, output, session) {
    })
}
