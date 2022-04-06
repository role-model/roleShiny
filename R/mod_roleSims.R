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

mod_roleSims_server <- function(id, sims_out){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
      # params <- reactiveValues()
      # params$species_meta <- input[[ns("sm")]]
      # params$individuals_meta <- input[[ns("jm")]]
      # params$individuals_local <- input[[ns("j")]]
      # params$dispersal_prob <- input[[ns("m")]]
      # params$speciation_local <-  input[[ns("nu")]
    
    s <- reactive({
    ###### Coalescent sims (fast) trial. 
      ### simulate the metacommunity
      # metacommunity ancestors, species, and their trait values
      # meta_com <- coalesc(input$jm, m = 1, theta = 100)
     
      # 
      # # metacommunity abundances (species, abundance, and relative abundance)
      # meta_abund <- abund(meta_com)
      # 
      # ### simulate the local communities (keeping it to a single community for now)
      # local_com <- coalesc(input$j, input$m, pool = meta_com$pool)
      # local_abund <- abund(local_com)
      # rank_abund <- local_abund$pool %>%
      #   arrange(desc(ab)) %>%
      #   mutate(rank = row_number())
      # 
      # return(rank_abund)
      # 
      
      ##### Forward sims
      
      ## forward-in-time simulation
      # parameterize deaths so the value is reasonable and at least 1
      if (input$j >= 50) {
        deaths <- round(input$j * 0.02)
      } else {
        deaths <- 1
      }
      
      # number of individuals may vary slightly depending on the how evenly the division between the number of individuals and the number of species is. Could also create a vector of this character string and sample it with replacement for the number of individuals in this community
      num_inds <- length(rep(as.character(1:input$sm),
                                    input$jm / input$sm))
      
      pool <- data.frame(ind = 1:num_inds, 
                     sp = rep(as.character(1:input$sm),
                              input$jm / input$sm),
                     tra = rep(NA, num_inds))
      
      t_sp <- data.frame(sp = as.character(1:input$sm), tra = runif(input$sm))
      
      pool$tra <- t_sp[pool$sp,]$tra
      
      initial <- pool[sample(1:num_inds, input$sm),]
      
      final <- forward(initial = initial, 
                               prob = input$m, 
                               d = deaths,
                               pool = pool,
                               gens = input$ts,
                               keep = TRUE)
      
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
