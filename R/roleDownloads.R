roleDownloadsUI <- function(id) {
    ns <- NS(id)
    tags$div(
        class = "control-set",

        h3("Downloads"),

        tags$div(
            class = "down-group",

            downloadButton(ns("downSim"), "download simulation"),
            downloadButton(ns("downScript"), "download script"),
            downloadButton(ns("downPlots"), "download plots")
        )
    )
}


roleDownloadsServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        output$downSim <- downloadHandler(
            filename = function() {
                paste("sim-", Sys.Date(), ".csv", sep = "")
            },
            content = function(file) {
                write.csv(mtcars, file)
            }
        )

        output$downScript <- downloadHandler(
            filename = function() {
                paste("script-", Sys.Date(), ".csv", sep = "")
            },
            content = function(file) {
                write.csv(mtcars, file)
            }
        )

        output$downPlots <- downloadHandler(
            filename = function() {
                paste("plots-", Sys.Date(), ".csv", sep = "")
            },
            content = function(file) {
                write.csv(mtcars, file)
            }
        )

    })
}
