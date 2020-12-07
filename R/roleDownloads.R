roleDownloadsUI <- function(id) {
    tags$div(
        class = "control-set",

        h3("Downloads"),

        tags$div(
            class = "down-group",

            actionLink("downSimLink", "click to download simulation"),
            actionLink("downScriptLink", "click to download script"),
            actionLink("downPlotsLink", "click to download plots")
        )
    )
}


roleDownloadsServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        downSim <- observeEvent(input$downSimLink, {
            print(input$downSimLink)
        })

        downScript <- observeEvent(input$downScriptLink, {
            print(input$downScriptLink)
        })

        downPlots <- observeEvent(input$downPlotsLink, {
            print(input$downPlotsLink)
        })
    })
}
