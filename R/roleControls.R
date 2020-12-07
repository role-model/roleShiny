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

        appState <- reactiveVal(State$ready)

        observeEvent(input$playBtn, {
            params <- list(
                species_meta = input$sm,
                individuals_meta = input$jm,
                individuals_local = input$j,
                dispersal_prob = input$m,
                speciation_local = input$nu)
            allSims(roleSimPlay(params, nstep = input$nstep, nout = input$nout))
        }, ignoreInit = TRUE)

        observeEvent(input$pauseBtn, {
        }, ignoreInit = TRUE)

        observeEvent(input$nextBtn, {
        }, ignoreInit = TRUE)
    })
}
