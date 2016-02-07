#' Load libraries
library(dplyr)
library(readr)
library(tidyr)

#' Setting
data_dir <- "./data/sports/football"
csv_filename <- "super-bowl-quarterbacks.csv"

#' Import dataset
sb_standings <- read_csv("https://raw.githubusercontent.com/timtrice/datasets/master/sports/football/sb-standings.csv")

#' Keep only Tm and StartingQB
sb_standings <- select(sb_standings, Tm, StartingQB)

#' StartingQB has multiple names per row. I want to know the max number of names 
#' in one row.
cqb <- c()
cqb <- lapply(sb_standings$StartingQB, function(x) { length(strsplit(x, ", ")[[1]])})
cqb <- unlist(cqb)
maxY <- max(cqb)

#' Now split into new variables while keeping original variable
sb_standings <- separate(sb_standings, StartingQB, c(paste0("QB", 1:4)), 
                         remove = FALSE, sep = ",", fill = "right")

#' Gather all QB Columns back to one. D1 will be removed later
sb_standings <- sb_standings %>% gather(D1, QB, QB1:QB4)

#' We have some NA's under value we can get rid of. 
sb_standings <- sb_standings[complete.cases(sb_standings$QB),]

#' I've spot checked the new QB column versus StartingQB and, happy with the 
#' results I'll drop StartingQB and D1
sb_standings <- select(sb_standings, Tm, QB)

#' Now I'll add a win/loss column
patt <- "([A-Za-z ']+).*?([0-9]{1})-([0-9]{1})."
sb_standings <- sb_standings %>% 
    group_by(QB) %>% 
    mutate(Wins = as.integer(sub(patt, "\\2", QB)), 
           Losses = as.integer(sub(patt, "\\3", QB)))

#' And I'll add a winning percentage (WP) then order by Name
sb_standings <- sb_standings %>% 
    group_by(QB, Tm) %>% 
    mutate(WP = as.numeric(sprintf("%0.3f", Wins/sum(Wins, Losses)))) %>% 
    arrange(QB)

#' I'll clean the W-L record from the QB varaible
sb_standings$QB <- gsub(patt, "\\1", sb_standings$QB)

#' Clean whitespace
sb_standings$QB <- trimws(sb_standings$QB)

#' Lastly, save the dataset
write.csv(sb_standings, paste(data_dir, csv_filename, sep = "/"), quote = FALSE, 
          row.names = FALSE)

#' And we're done
