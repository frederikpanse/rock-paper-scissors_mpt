# get cleaned data
source("get_data.R")
data_Player_A <- get_data("simulated_data_p_1000.csv")[1]$Player_A
data_Player_B <- get_data("simulated_data_p_1000.csv")[2]$Player_B

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
pdf("../doc/fig/simulated_p.pdf", height=5.5, width=8, pointsize=12)

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
