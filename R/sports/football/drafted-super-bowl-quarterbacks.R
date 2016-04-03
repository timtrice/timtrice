library(readr)
library(dplyr)
library(ggplot2)

source("./R/functions/multiplot.R", echo = FALSE)

dqb <- read_csv("https://raw.githubusercontent.com/timtrice/datasets/master/sports/football/draft-qb.csv")
sbqb <- read_csv("https://raw.githubusercontent.com/timtrice/datasets/master/sports/football/super-bowl-quarterbacks.csv")

df <- left_join(sbqb, dqb, by = "Name")

rm(dqb, sbqb)

#' Get only the variables we need
df <- select(df, Tm.x, Name, Wins, Losses, WP, Year, Rnd, Pick, College)

#' * What round produces the most/least Super Bowl starts? 
ptitle <- "Super Bowl Starts by Draft Round"
tmp <- df %>% 
    group_by(Rnd) %>% 
    summarise(Games = sum(Wins, Losses))

ggplot(tmp, aes(x = factor(Rnd), y = Games, fill = factor(Rnd))) + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = Games), vjust = -0.75) + 
    expand_limits(y = c(0, 52)) + 
    theme_light() + 
    theme(legend.position = "none") + 
    xlab("Draft Round") + 
    ylab("Games") + 
    ggtitle(ptitle)

#' * What is the proportion of quarterbacks drafted by round?
ptitle <- "Proportion of Super Bowl Starting Quarterbacks by Draft Round"
tmp <- df %>% 
    group_by(Rnd) %>% 
    summarise(N = n(), 
              NProp = as.numeric(sprintf("%1.3f", N/sum(tmp$N))))

ggplot(tmp, aes(x = factor(Rnd), y = NProp, fill = factor(Rnd))) + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = NProp), vjust = -0.75) + 
    theme_light() + 
    theme(legend.position = "none") + 
    xlab("Draft Round") + 
    ylab("Proportion") + 
    ggtitle(ptitle)

#' * What is the win/loss record of Super Bowl starting quarterbacks, by round?

#' * What is the total number of Super Bowl starts by pick?

#' * What is the ranking of Super Bowl starting quarterbacks?

#' * Compared to draft position, what starting quarterbacks are the outliers?

# Games started by draft round
ptitle <- "Super Bowls Started by Draft Round"
s <- dt[, .(G = sum(Wins, Losses)), by = Rnd][order(Rnd)]

p1 <- ggplot(s, aes(x = factor(Rnd), y = G, fill = factor(Rnd))) + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = G), vjust = -0.75) + 
    expand_limits(y = c(0, 52)) + 
    theme_light() + 
    theme(legend.position = "none") + 
    xlab("Draft Round") + 
    ylab("Games") + 
    ggtitle(ptitle)

kable(t(s$G), col.names = s$Rnd, align = "c", caption = ptitle)

# Games won by draft round
ptitle <- "Super Bowls Wins/Losses by Draft Round"
s <- dt[, .(W = sum(Wins), L = sum(Losses)), by = Rnd][order(Rnd)] %>% 
    gather(key, value, W, L)

p2 <- ggplot(s, aes(x = factor(Rnd), y = value, fill = key)) + 
    geom_bar(stat = "identity", position = position_dodge()) + 
    geom_text(aes(label = value), position = position_dodge(width = 0.9), 
              vjust = -0.75) + 
    expand_limits(y = c(0, 28)) + 
    theme_light() + 
    theme(legend.position = c(0.95, 0.85), legend.title = element_blank()) + 
    xlab("Draft Round") + 
    ylab("Wins/Losses") + 
    ggtitle(ptitle)

s <- spread(s, key, value)

kable(t(s[2:3]), col.names = s$Rnd, align = "c", caption = ptitle)

multiplot(p1, p2, cols = 2)

# Games by Pick
ptitle <- "Super Bowls Started by Pick"
s <- dt[, .(G = sum(Wins, Losses)), by = Pick][order(Pick)]

s$Pick <- factor(s$Pick, levels = rev(s$Pick))

ggplot(s, aes(x = Pick, y = G, fill = Pick)) + 
    geom_bar(stat = "identity") + 
    coord_flip(ylim = c(0, 21)) + 
    geom_text(aes(label = G), hjust = -0.75) + 
    theme_light() + 
    theme(legend.position = "none") + 
    xlab("Draft Round") + 
    ylab("Games") + 
    ggtitle(ptitle) + 
    geom_text(label = "(Tom Brady, New England Patriots)", x = 5, y = 6, 
              hjust = -0.1) + 
    geom_text(label = "(Roger Staubach, Dallas Cowboys)", x = 10, y = 4, 
              hjust = -0.1) + 
    geom_text(label = "(Joe Montana, San Francisco 49ers)", x = 15, y = 4, 
              hjust = -0.1)

