library(socorro)
library(pika)
library(viridis)

parArg <- list(mar = c(2, 2, 0, 0) + 0.5, mgp = c(1.5, 0.25, 0), cex = 1.4, tcl = -0.25)

# sad plot
set.seed(1)
x <- sad(rfish(100, 0.1), keepData = TRUE)

pdf('mockup/fig_sad.pdf', width = 4, height = 4)
par(parArg)
plot(x, ptype = 'rad', log = 'y', lwd = 1.5)
dev.off()

# hill ts plot
set.seed(1)
h <- cumsum(rnorm(500, 0.05))
h[h < 0] <- 0
h <- h / (1.1 * max(h))
h2 <- h * 0.5
h3 <- h * 0.25
hcol <- viridis(3, end = 0.9)

pdf('mockup/fig_hillTS.pdf', width = 6, height = 4)
par(parArg)
plot(h, type = 'l', xlab = 'Generations', ylab = 'Abundance Hill Numbers',
     col = hcol[1], lwd = 2)
lines(h2, col = hcol[2], lwd = 2)
lines(h3, col = hcol[3], lwd = 2)
dev.off()
