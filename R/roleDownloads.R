roleDownloadsUI <- function(id) {
    tags$div(
        class = "control-set",

        h3("Downloads"),

        tags$div(
            class = "down-group",

            downloadButton("downSim", "download simulation"),
            downloadButton("downScript", "download script"),
            downloadButton("downPlots", "download plots")
        )
    )
}


roleDownloadsServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        downScript <- observeEvent(input$downScriptLink, {
            print(input$downScriptLink)
        })

        downPlots <- observeEvent(input$downPlotsLink, {
            print(input$downPlotsLink)
        })
    })
}
