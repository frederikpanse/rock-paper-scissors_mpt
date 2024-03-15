library(Hmisc)

get_data <- function(file) {

  data <- read.csv(paste('../dat/', file, sep = ""))

  names(data) <- c("Round", "Mona", "Chiara")
  
  data$Mona_lag1 <- Lag(data$Mona) 
  
  data$Chiara_lag1 <- Lag(data$Chiara)
  
  
  data$Mona_win <- ifelse(data$Mona == data$Chiara, NA,'')
  data[data$Mona == data$Chiara,]$Mona_win <- NA
  data[(data$Mona == 1) & (data$Chiara == 3),]$Mona_win <- 1
  data[(data$Mona == 3) & (data$Chiara == 1),]$Mona_win <- 0
  data[(data$Mona == 2) & (data$Chiara == 1),]$Mona_win <- 1
  data[(data$Mona == 1) & (data$Chiara == 2),]$Mona_win <- 0
  data[(data$Mona == 2) & (data$Chiara == 3),]$Mona_win <- 0
  data[(data$Mona == 3) & (data$Chiara == 2),]$Mona_win <- 1
  
  #####
  data$Mona_win <- as.numeric(data$Mona_win)
  
  data$chiara_win <- 1-data$Mona_win
  data$chiara_win <- as.numeric(data$chiara_win)
  
  data[is.na(data$Mona_win),]$Mona_win <- 99
  data[is.na(data$chiara_win),]$chiara_win <- 99
  
  data$mona_cond <- Lag(data$Mona_win)
  data$chiara_cond <- Lag(data$chiara_win)
  data <- data[complete.cases(data), ]
  
  # getting model 1 categories
  # Mona
  data[(data$Mona == 2) & (data$Chiara_lag1 == 1), "mona_m1"] <- 1 # opp stays
  data[(data$Mona == 3) & (data$Chiara_lag1 == 2), "mona_m1"] <- 1
  data[(data$Mona == 1) & (data$Chiara_lag1 == 3), "mona_m1"] <- 1
  data[(data$Mona == 3) & (data$Chiara_lag1 == 1), "mona_m1"] <- 2 # opp beats own
  data[(data$Mona == 1) & (data$Chiara_lag1 == 2), "mona_m1"] <- 2 # prev resp
  data[(data$Mona == 2) & (data$Chiara_lag1 == 3), "mona_m1"] <- 2
  data[(data$Mona == 1) & (data$Chiara_lag1 == 1), "mona_m1"] <- 3 # opp loses
  data[(data$Mona == 2) & (data$Chiara_lag1 == 2), "mona_m1"] <- 3 # to own prev
  data[(data$Mona == 3) & (data$Chiara_lag1 == 3), "mona_m1"] <- 3 # resp
  
  # Chiara
  data[(data$Chiara == 2) & (data$Mona_lag1 == 1), "chiara_m1"] <- 1 # opp stays
  data[(data$Chiara == 3) & (data$Mona_lag1 == 2), "chiara_m1"] <- 1
  data[(data$Chiara == 1) & (data$Mona_lag1 == 3), "chiara_m1"] <- 1
  data[(data$Chiara == 3) & (data$Mona_lag1 == 1), "chiara_m1"] <- 2 # opp beats own
  data[(data$Chiara == 1) & (data$Mona_lag1 == 2), "chiara_m1"] <- 2 # prev resp
  data[(data$Chiara == 2) & (data$Mona_lag1 == 3), "chiara_m1"] <- 2
  data[(data$Chiara == 1) & (data$Mona_lag1 == 1), "chiara_m1"] <- 3 # opp loses
  data[(data$Chiara == 2) & (data$Mona_lag1 == 2), "chiara_m1"] <- 3 # to own prev
  data[(data$Chiara == 3) & (data$Mona_lag1 == 3), "chiara_m1"] <- 3 # resp
  
  # getting model 2 categories
  # Mona
  data[(data$Mona == 1) & (data$Mona_lag1 == 1), "mona_m2"] <- 1 # stay
  data[(data$Mona == 2) & (data$Mona_lag1 == 2), "mona_m2"] <- 1 
  data[(data$Mona == 3) & (data$Mona_lag1 == 3), "mona_m2"] <- 1 
  data[(data$Mona == 2) & (data$Mona_lag1 == 1), "mona_m2"] <- 2 # beat own
  data[(data$Mona == 3) & (data$Mona_lag1 == 2), "mona_m2"] <- 2
  data[(data$Mona == 1) & (data$Mona_lag1 == 3), "mona_m2"] <- 2
  data[(data$Mona == 3) & (data$Mona_lag1 == 1), "mona_m2"] <- 3 # lose to own
  data[(data$Mona == 1) & (data$Mona_lag1 == 2), "mona_m2"] <- 3 
  data[(data$Mona == 2) & (data$Mona_lag1 == 3), "mona_m2"] <- 3
  
  # Chiara
  data[(data$Chiara == 1) & (data$Chiara_lag1 == 1), "chiara_m2"] <- 1 # stay
  data[(data$Chiara == 2) & (data$Chiara_lag1 == 2), "chiara_m2"] <- 1 
  data[(data$Chiara == 3) & (data$Chiara_lag1 == 3), "chiara_m2"] <- 1 
  data[(data$Chiara == 2) & (data$Chiara_lag1 == 1), "chiara_m2"] <- 2 # beat own
  data[(data$Chiara == 3) & (data$Chiara_lag1 == 2), "chiara_m2"] <- 2
  data[(data$Chiara == 1) & (data$Chiara_lag1 == 3), "chiara_m2"] <- 2
  data[(data$Chiara == 3) & (data$Chiara_lag1 == 1), "chiara_m2"] <- 3 # lose to own
  data[(data$Chiara == 1) & (data$Chiara_lag1 == 2), "chiara_m2"] <- 3 
  data[(data$Chiara == 2) & (data$Chiara_lag1 == 3), "chiara_m2"] <- 3
  
  ###
  # getting data_mona_m2
  freq <- as.vector(xtabs(~ mona_m2 + mona_cond, data))
  cond <- rep(c(0, 1, 99), each = 3)
  cat <- rep(1:3, 3)
  data_mona_m2 <- data.frame(cond = cond, cat = cat, freq = freq)
  
  # getting data_chiara_m2
  freq <- as.vector(xtabs(~ chiara_m2 + chiara_cond, data))
  cond <- rep(c(0, 1, 99), each = 3)
  cat <- rep(1:3, 3)
  data_chiara_m2 <- data.frame(cond = cond, cat = cat, freq = freq)
  
  data_m2 <- list(Player_A = data_mona_m2, Player_B = data_chiara_m2)
  return(data_m2)

}
