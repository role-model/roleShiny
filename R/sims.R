id <- "roleControls"

getSims <- function(input, allSims) {
    ns <- NS(id)
    observe({
        nstep <- input[[ns("nstep")]]

        print(allSims())
        print(is.null(allSims()))
        print(length(allSims()))
        print(nstep)
        print(input)
        print(input[[ns("sm")]])

        # if (length(allSims()) < nstep) {
        #     nout <- input[[ns("nout")]]
        #     nstep <- min(nstep, nout * input[[ns("nvis")]])
        #     nout <- input[[ns("nout")]]
        #     params <- list(
        #         species_meta = input[[ns("sm")]],
        #         individuals_meta = input[[ns("jm")]],
        #         individuals_local = input[[ns("j")]],
        #         dispersal_prob = input[[ns("m")]],
        #         speciation_local = input[[ns("nu")]])
        #
        #     init <- if (length(allSims()) == 0) NULL else allSims()[[length(allSims())]]
        #
        #     f <- future({
        #         roleSimPlay(params, init = init, nstep = nstep, nout = nout)
        #     }, seed = TRUE)
        #
        #     f
        # }
    })
}
