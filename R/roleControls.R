source("R/sims.R")

roleControlsUI <- function(id) {
    ns <- NS(id)
    tags$div(
        class = "control-set but-group",
        actionButton(ns("playBtn"), icon("play")),
        actionButton(ns("pauseBtn"), icon("pause")),
        actionButton(ns("nextBtn"), icon("step-forward")),
        bsTooltip(ns("playBtn"), "Play the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("pauseBtn"), "Pause the simulation", placement = "bottom", trigger = "hover"),
        bsTooltip(ns("nextBtn"), "Step simulation forward", placement = "bottom", trigger = "hover")
    )
}


roleControlsServer <- function(id, allSims) {
    moduleServer(id, function(input, output, session) {

        observeEvent(input$playBtn, {
            sims <- getSims(input, allSims)
            print("before")
            untar("./data/MESS-simulated-data_small.tar.gz", list = TRUE)
            # X <- read.csv(MESS-simulated-data/params-sim-data.txt)
             # print(files)
            print("after")
            # params <- list(species_meta = 100,
            #                individuals_meta = 10000,
            #                individuals_local = 1000,
            #                dispersal_prob = 0.1,
            #                speciation_local = 0.01)
            # testSim <- roleSimPlay(params, nstep = 100, nout = 5)
            # print(testSim)
        }, ignoreInit = TRUE)

        observeEvent(input$pauseBtn, {
        }, ignoreInit = TRUE)

        observeEvent(input$nextBtn, {
        }, ignoreInit = TRUE)

    })
}
