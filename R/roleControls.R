library(roleR)

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
            allSims(list())
        }, ignoreInit = TRUE)

        observeEvent(input$pauseBtn, {
        }, ignoreInit = TRUE)

        observeEvent(input$nextBtn, {
        }, ignoreInit = TRUE)

        observe({
            if (!is.null(allSims()) && length(allSims()) < input$nstep) {
                print(length(allSims()))

                every <- min(input$nstep, input$nout * input$nvis)

                nstep <- every
                nout <- input$nout
                params <- list(
                    species_meta = input$sm,
                    individuals_meta = input$jm,
                    individuals_local = input$j,
                    dispersal_prob = input$m,
                    speciation_local = input$nu)

                init <- if (length(allSims()) == 0) NULL else allSims()[[length(allSims())]]

                f <- future({
                    roleSimPlay(params, init = init, nstep = nstep, nout = nout)
                }, seed = TRUE)

                while (!resolved(f)) {
                    print('waiting...')
                }  # Don't block

                allSims(append(allSims(), value(f)))
            } else {
                print('done')
                print(length(allSims()))
            }
        })
    })
}
