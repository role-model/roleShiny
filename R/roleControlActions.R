
play <- function(buttonStates) {
    buttonStates$canPlay(FALSE)
    buttonStates$canPause(TRUE)
    buttonStates$canNext(FALSE)
}


pause <- function(buttonStates) {
    buttonStates$canPlay(TRUE)
    buttonStates$canPause(FALSE)
    buttonStates$canNext(TRUE)
}

next_ <- function(buttonStates) {
    buttonStates$canPlay(TRUE)
    buttonStates$canPause(FALSE)
    buttonStates$canNext(TRUE)
}


reset <- function(buttonStates) {
    buttonStates$canPlay(TRUE)
    buttonStates$canPause(FALSE)
    buttonStates$canNext(TRUE)
}
