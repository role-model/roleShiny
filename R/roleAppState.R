State <- list("init" = 0, "playing" = 1, "paused" = 2, "next_" = 3)

appState <- reactiveVal(State$init)

play <- function() {appState(State$playing)}
pause <- function() {appState(State$paused)}
next_ <- function() {appState(State$next_)}
reset <- function() {appState(State$init)}

canPlay <- function(selectCount) {
    (appState() %in% c(State$init, State$paused, State$next_)
     && selectCount() > 0)
}

canPause <- function(selectCount) {
    (appState() %in% c(State$playing)
     && selectCount() > 0)
}

canNext <- function(selectCount) {
    (appState() %in% c(State$init, State$paused, State$next_)
     && selectCount() > 0)
}

canPlot <- reactive({
    print(appState())
    appState() %in% c(State$playing, State$next_)
})
