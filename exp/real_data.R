# get cleaned data
source("get_data.R")
data_mona <- get_data("real_data.csv")[1]$Player_A
data_chiara <- get_data("real_data.csv")[2]$Player_B

library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

datlist_mona <- list(y = data_mona$freq)
datlist_chiara <- list(y = data_chiara$freq)

m_mona <- stan("../src/rps_mpt.stan", data = datlist_mona)
print(m_mona, pars = c("c1", "c2","c3","b1", "b2", "b3"), probs = c(.025, .975))

m_chiara <- stan("../src/rps_mpt.stan", data = datlist_chiara)
print(m_chiara, pars = c("c1", "c2","c3","b1", "b2", "b3"), probs = c(.025, .975))


# getting the samples
c_mona <- data.frame("lose" = extract(m_mona)$c1,
                     "win"  = extract(m_mona)$c2,
                     "draw" = extract(m_mona)$c3)
b_mona <- data.frame("lose" = extract(m_mona)$b1,
                     "win"  = extract(m_mona)$b2,
                     "draw" = extract(m_mona)$b3)

c_chiara <- data.frame("lose" = extract(m_chiara)$c1,
                       "win"  = extract(m_chiara)$c2,
                       "draw" = extract(m_chiara)$c3)
b_chiara <- data.frame("lose" = extract(m_chiara)$b1,
                       "win"  = extract(m_chiara)$b2,
                       "draw" = extract(m_chiara)$b3)

## Boxplots
pdf("../doc/fig/mona_chiara.pdf", height=5.5, width=8, pointsize=12)

par(mfrow = c(2, 2), mai = c(.4, .7, .1, .1), mgp = c(3, .7, 0))

# c parameter Mona
boxplot(c_mona, ylim = 0:1, horizontal = TRUE, yaxt = "n", 
	col = "#add8e6", ylab = "Mona")
axis(2, 1:3, expression(s[lose], s[win], s[draw]), las = 1)
abline(v = 1/3, lty = 3)

# b parameter Mona
boxplot(b_mona, ylim = 0:1, horizontal = TRUE, yaxt = "n", col = "#add8e6")
axis(2, 1:3, expression(b[lose], b[win], b[draw]), las = 1)
abline(v = 1/2, lty = 3)

# c parameter Chiara
boxplot(c_chiara, ylim = 0:1, horizontal = TRUE, yaxt = "n", 
	col = "#add8e6", ylab = "Chiara")
axis(2, 1:3, expression(s[lose], s[win], s[draw]), las = 1)
abline(v = 1/3, lty = 3)

# b parameter Chiara
boxplot(b_chiara, ylim = 0:1, horizontal = TRUE, yaxt = "n", col = "#add8e6")
axis(2, 1:3, expression(b[lose], b[win], b[draw]), las = 1)
abline(v = 1/2, lty = 3)

dev.off()


# Densities
make_densities <- function(samples, x_value) {
  pdf(paste("../doc/fig/", deparse(substitute(samples)), ".pdf", sep = ""), 
      height=5.5, width=8, pointsize=12)
  par(mfrow = c(1, 3), mai = c(.6, .6, .1, .1), mgp = c(2, .7, 0))

  densities <- c()
  bayes_factors <- c()
  
  for(i in 1:3) {
    density_out <- samples[ ,i] |> density()
    densities[i] <- approx(density_out$x, density_out$y, xout = x_value)$y
    bayes_factors[i] <- 1 / densities[i]
  
    plot(density_out, xlim = 0:1, ylim = c(0, 11), 
	 xlab = ifelse(x_value == 1/3, "p(stay)", "p(beat)"), main = "",
         col = "#add8e6", lwd = 3)
    text(x = .8, y = 9.2, paste("BF[10] =", round(bayes_factors[i], 2)))
    text(x = .8, y = 8.8, paste("BF[01] =", round(densities[i], 2)))
    curve(dbeta(x, 1, 1), 0, 1, lty = 2, add = TRUE)
    abline(v = x_value, lty = 3)
  }
  
  dev.off()
}

make_densities(c_mona, 1/3)
make_densities(b_mona, 1/2)
make_densities(c_chiara, 1/3)
make_densities(b_chiara, 1/2)
