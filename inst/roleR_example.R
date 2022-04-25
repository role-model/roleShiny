#roleR example 

timestep <- input$nstep/20
if(timestep < 10){timestep <- 10}

params <- roleParams(nruns=1,niter=input$nstep,niterTimestep=timestep,defaults=TRUE)
params <- setParam(params,"species_meta",input$sm)
params <- setParam(params,"individuals_local",input$j)
params <- setParam(params,"individuals_meta",input$jm)
params <- setParam(params,"dispersal_prob",input$m)
params <- setParam(params,"speciation_local",input$nu)

# send this process to the background so Shiny users can do other things
final_gb <- callr::r_bg(roleR::roleExperiment, args = list(params=params), 
                        supervise = TRUE,
                        package = TRUE)