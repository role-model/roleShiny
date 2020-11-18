
play <- function(appState) {
    appState$canPlay(FALSE)
    appState$canPause(TRUE)
    appState$canNext(FALSE)
}


pause <- function(appState) {
    appState$canPlay(TRUE)
    appState$canPause(FALSE)
    appState$canNext(TRUE)
}

next_ <- function(appState) {
    appState$canPlay(TRUE)
    appState$canPause(FALSE)
    appState$canNext(TRUE)
}


reset <- function(appState) {
    appState$canPlay(TRUE)
    appState$canPause(FALSE)
    appState$canNext(TRUE)
}
