library(ggplot2)
library(data.table)
library(tidyr)
library(knitr)
library(xtable)

source("./R/functions/multiplot.R", echo = FALSE)

# Import dataset
# This dataset is available at: 
# https://github.com/timtrice/timtrice/blob/master/data/sports/football/sbqb.csv
draft_qb_csv <- "./data/sports/football/drafted-qb-super-bowl.csv"

# Get column classes for draft_qb
column_class = sapply(read.csv(draft_qb_csv, nrows = 100), class)

dt <- fread(draft_qb_csv, colClasses = column_class)

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", 
                "#0072B2", "#D55E00", "#CC79A7")

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

