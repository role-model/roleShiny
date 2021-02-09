# Temporary module

all.types = c('Abundance', 'Trait', 'pi', 'phylo')

roleDistAnim <- function(roleSim, type = all.types) {
    type <- match.arg(type, all.types)

    # Create a single data frame from all of the simulation steps
    all_data = vector('list', length(roleSim))
    for (i in 1:length(roleSim)) {
        print(i)
        sim <- roleSim[[i]]
        x <- sim$local_comm[[type]][sim$local_comm$Abundance > 0]
        df <- data.frame(rank = 1:length(x), y = sort(as.numeric(x), TRUE))
        df$step <- i
        all_data[[i]] <- df
    }
    all_data <- rbind.fill(all_data)

    fig <- plot_ly(
        all_data, x = ~rank, y = ~y, frame = ~step, type = 'scatter', mode = 'markers',
        marker = list(color = 'transparent', size = 8, line = list(color = 'black', width = 1.5)))

    fig <- layout(
        fig,
        xaxis = list(zeroline = FALSE, title = 'Species Rank'),
        yaxis = list(zeroline = FALSE, title = type,
                     type = ifelse(type != 'Trait', 'log', 'linear')))

    fig <- animation_button(fig, visible = FALSE)
    fig <- animation_slider(fig, hide = TRUE)

    fig
}

roleTSAnim <- function(roleSim, type = all.types) {
    'stub'
}
