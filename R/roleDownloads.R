### For rendering RMarkdown doc with the code
# Copy report to temporary directory. This is mostly important when
# deploying the app, since often the working directory won't be writable
# will move this to the util.R script after development

report_path <- tempfile(fileext = ".Rmd")
file.copy("report.Rmd", report_path, overwrite = TRUE)

render_report <- function(input, output, params) {
    rmarkdown::render(input,
                      output_file = output,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
}



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
            filename = "report.html",
            content = function(file) {
                params <- list(n = 10)
                
                id <- showNotification(
                    "Rendering report...", 
                    duration = NULL, 
                    closeButton = FALSE
                )
                on.exit(removeNotification(id), add = TRUE)
                
                callr::r(render_report,
                         list(input = report_path, output = file, params = params)
                )
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
