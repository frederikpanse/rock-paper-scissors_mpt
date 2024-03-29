# get cleaned data
source("get_data.R")
data_Player_A <- get_data("simulated_data_g_1000.csv")[1]$Player_A
data_Player_B <- get_data("simulated_data_g_1000.csv")[2]$Player_B

library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

datlist_Player_A <- list(y = data_Player_A$freq)
datlist_Player_B <- list(y = data_Player_B$freq)

m_Player_A <- stan("../src/rps_mpt.stan", data = datlist_Player_A)
print(m_Player_A, pars = c("c1", "c2","c3","b1", "b2", "b3"), probs = c(.025, .975))

m_Player_B <- stan("../src/rps_mpt.stan", data = datlist_Player_B)
print(m_Player_B, pars = c("c1", "c2","c3","b1", "b2", "b3"), probs = c(.025, .975))


# getting the samples
c_Player_A <- data.frame("lose" = extract(m_Player_A)$c1,
                         "win"  = extract(m_Player_A)$c2,
                         "draw" = extract(m_Player_A)$c3)
b_Player_A <- data.frame("lose" = extract(m_Player_A)$b1,
                         "win"  = extract(m_Player_A)$b2,
                         "draw" = extract(m_Player_A)$b3)

c_Player_B <- data.frame("lose" = extract(m_Player_B)$c1,
                         "win"  = extract(m_Player_B)$c2,
                         "draw" = extract(m_Player_B)$c3)
b_Player_B <- data.frame("lose" = extract(m_Player_B)$b1,
                         "win"  = extract(m_Player_B)$b2,
                         "draw" = extract(m_Player_B)$b3)

# Boxplots
pdf("../doc/fig/simulated_g.pdf", height=5.5, width=8, pointsize=12)

par(mfrow = c(2, 2), mai = c(.4, .7, .1, .1), mgp = c(3, .7, 0))

# c parameter Player_A
boxplot(c_Player_A, ylim = 0:1, horizontal = TRUE, yaxt = "n", 
	col = "#add8e6", ylab = "Player_A")
axis(2, 1:3, expression(s[lose], s[win], s[draw]), las = 1)
abline(v = 1/3, lty = 3)

# b parameter Player_A
boxplot(b_Player_A, ylim = 0:1, horizontal = TRUE, yaxt = "n", col = "#add8e6")
axis(2, 1:3, expression(b[lose], b[win], b[draw]), las = 1)
abline(v = 1/2, lty = 3)

# c parameter Player_B
boxplot(c_Player_B, ylim = 0:1, horizontal = TRUE, yaxt = "n", 
	col = "#add8e6", ylab = "Player_B")
axis(2, 1:3, expression(s[lose], s[win], s[draw]), las = 1)
abline(v = 1/3, lty = 3)

# b parameter Player_B
boxplot(b_Player_B, ylim = 0:1, horizontal = TRUE, yaxt = "n", col = "#add8e6")
axis(2, 1:3, expression(b[lose], b[win], b[draw]), las = 1)
abline(v = 1/2, lty = 3)

dev.off()


# Densities
make_densities <- function(samples, x_value) {
  pdf(paste("../doc/fig/", deparse(substitute(samples)), "_g.pdf", sep = ""), 
      height=3, width=8, pointsize=12)
  par(mfrow = c(1, 3), mai = c(.5, .5, .3, .1), mgp = c(2, .7, 0))

  densities <- c()
  bayes_factors <- c()
  
  for(i in 1:3) {
    density_out <- samples[ ,i] |> density()
    densities[i] <- approx(density_out$x, density_out$y, xout = x_value)$y
    bayes_factors[i] <- 1 / densities[i]
  
    plot(density_out, xlim = 0:1, ylim = c(0, 15.8), 
	 xlab = ifelse(x_value == 1/3, "s = p(stay)", "b = p(beat)"), 
	 main = ifelse(i == 1, "lose", ifelse(i == 2, "win", "draw")),
         col = "#add8e6", lwd = 3)
    text(x = .82, y = 14, paste("BF[10] =", round(bayes_factors[i], 2)))
    text(x = .82, y = 13, paste("BF[01] =", round(densities[i], 2)))
    curve(dbeta(x, 1, 1), 0, 1, lty = 2, add = TRUE)
    abline(v = x_value, lty = 3)
  }
  
  dev.off()
}

make_densities(c_Player_A, 1/3)
make_densities(b_Player_A, 1/2)
make_densities(c_Player_B, 1/3)
make_densities(b_Player_B, 1/2)
