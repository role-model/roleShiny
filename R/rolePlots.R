rolePlotsUI <- function(id, name1, name2, check1, check2) {
    ns <- NS(id)

    fluidRow(

        conditionalPanel(check1, class = "cond-panel", ns = ns,
                         column(5, plotlyOutput(ns(name1)))
        ),

        conditionalPanel(check2, class = "cond-panel", ns = ns,
                         column(7, plotlyOutput(ns(name2)))
        )
    )
}


rolePlotsServer <- function(id, name, func, type, checkBox, allSims) {
    moduleServer(id, function(input, output, session) {
        observe({
            if (!is.null(allSims()) && input[[checkBox]]) {
                fig <- func(allSims(), type)
                output[[name]] <- renderPlotly({fig})
            }
        })
    })
}
