library(shiny)
library(shinyBS)

source("R/util.R")


labelOpen <- '<div class="param-label">'
labelGreekOpen <- '<div class="param-label greek">'
labelClose <- "</div>"


roleParamUI <- function(id, name, label = "", min = 0, max = 100000, value = 100, tip = "", isGreek = FALSE) {
    ns <- NS(id)
    opener = if (isGreek) labelGreekOpen else labelOpen
    tagList(
        HTML(paste(opener, label, labelClose)),
        tags$div(
            class = "param-wrapper",
            sliderInput(ns(name), label = "", min = min, max = max, value = value, ticks = FALSE),
            bsTooltip(ns(name), tip)
        )
    )
}


roleParamServer <- function(id) {
    moduleServer(id, function(input, output, session) {
    })
}
