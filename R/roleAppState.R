library(shiny)

State <- list("ready" = 1, "busy" = 2)

appState <- reactiveVal(State$ready)
selectCount <- reactiveVal(0)

play <- function() {appState(State$busy)}
pause <- function() {appState(State$ready)}
next_ <- function() {appState(State$busy)}
reset <- function() {appState(State$ready)}

canPlay <- reactive({appState() == State$ready && selectCount() > 0})
canPause <- reactive({appState() == State$busy && selectCount() > 0})
canNext <- reactive({appState() == State$ready && selectCount() > 0})
canPlot <- reactive({appState() == State$busy && selectCount() > 0})

setSelectCount <- function(checkBox) {
    bump <- if (checkBox) 1 else -1
    selectCount(selectCount() + bump)
}
