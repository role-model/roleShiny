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
                    id,
                    "sm",
                    label = "S<sub>m",
                    min = 0,
                    max = 10000,
                    value = 100,
                    tip = "The species metaparameter"),
                roleParamUI(
                    id,
                    "jm",
                    label = "J<sub>m",
                    min =  0,
                    max = 100000,
                    value = 10000,
                    tip = "The individuals metaparameter"),
                roleParamUI(
                    id,
                    "j",
                    label = "J",
                    min = 0,
                    max = 100000,
                    value = 100,
                    tip = "The individuals local parameter"),
                roleParamUI(
                    id,
                    "m",
                    label = "m",
                    min = 0,
                    max = 1.0,
                    value = 0.1,
                    tip = "The dispersal probability"),
                roleParamUI(
                    id,
                    "nu",
                    label = "&#957;",
                    min = 0,
                    max = 1.0,
                    value = 0.01,
                    tip = "The speciation local parameter",
                    isGreek = TRUE)
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
                    id,
                    "nstep",
                    label = "n<sub>step</sub>",
                    min = 1,
                    max = 100,
                    value = 10,
                    tip = "The number of steps"),
                roleParamUI(
                    id,
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
