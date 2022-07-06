#' roleSims UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 

library(ecolottery)
library(callr)

mod_roleSims_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' roleSims Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param sims_out Path to temporary file to house simulations
#'
#' @noRd 
#' 
library(dplyr)

mod_roleSims_server <- function(id, sims_out, is_neutral = TRUE){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    s <- reactive({
      
      ##### Forward sims
      
      ## forward-in-time simulation
      # parameterize deaths so the value is reasonable and at least 1
      if (input$j >= 50) {
        deaths <- round(input$j * 0.01)
      } else {
        deaths <- 1
      }
      
      # number of individuals may vary slightly depending on the how evenly the division between the number of individuals and the number of species is. Could also create a vector of this character string and sample it with replacement for the number of individuals in this community
      
      meta_comm <- coalesc(input$jm, m = 1, theta = 50)
      
      pool <- meta_comm$pool
      
      
      initial <- pool[sample(1:input$jm, input$j),]
      
      # environmental filtering function
      filt_gaussian <- function(t, x, sigma) {
        exp(-(x - t)^2 / (2 * sigma^2))
      }
      
      
      withProgress(message = "Simulation in progress...", 
                   detail = "May take a while", 
                   value = 0,
                   { incProgress(0.75)
                     # send this process to the background so Shiny users can do other things
                     # final_gb <- callr::r_bg(ecolottery::forward, args = list(initial = initial, 
                     #                                                          prob = input$m, 
                     #                                                          d = deaths,
                     #                                                          pool = pool,
                     #                                                          gens = input$nstep,
                     #                                                          filt = filt_fun,
                     #                                                          keep = TRUE), 
                     #                         supervise = TRUE,
                     #                         package = TRUE)
                     # 
                     # # wait until the process is done before returning the results
                     # final_gb$wait()
                     # final_gb$is_alive()
                     # 
                     # final <- final_gb$get_result()
                     
                     # apply filtering if the user wants it
                     if (!is_neutral) {
                       if (input$env_filt == "Stabilizing") {
                         
                         final <- ecolottery::forward(
                           initial = initial,
                           prob = input$m,
                           d = deaths,
                           pool = pool,
                           gens = input$nstep,
                           filt = function(x) filt_gaussian(t = input$filt_mean, 
                                                            x = x,
                                                            sigma = input$filt_sd),
                           keep = TRUE)
                         
                       } else if (input$env_filt == "Disruptive"){
                         
                         final <- ecolottery::forward(
                           initial = initial,
                           prob = input$m,
                           d = deaths,
                           pool = pool,
                           gens = input$nstep,
                           filt = function(x) abs(0.5 - x),
                           keep = TRUE)
                       } else {
                         final <- ecolottery::forward(
                           initial = initial,
                           prob = input$m,
                           d = deaths,
                           pool = pool,
                           gens = input$nstep,
                           keep = TRUE)
                       }
                     }
                     
                     
                     else {
                       final <- ecolottery::forward(
                         initial = initial,
                         prob = input$m,
                         d = deaths,
                         pool = pool,
                         gens = input$nstep,
                         keep = TRUE)
                     }
                     
                     
                   })
      
      
      return(final)

      }) %>%
      bindEvent(input$playBtn)
    
    

    observe({
      s()
      saveRDS(s(), file = sims_out)
    })
    
      
      
  })
}

## To be copied in the UI
# mod_roleSims_ui("roleSims_1")
    
## To be copied in the server
# mod_roleSims_server("roleSims_1")
