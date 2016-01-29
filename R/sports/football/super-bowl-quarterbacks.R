library(data.table)
library(dplyr)
library(tidyr)

# Import datasets
sb_standings_csv <- "./data/sports/football/sb_standings.csv"

# Get column classes for sb_standings
column_class = sapply(read.csv(sb_standings_csv, nrows = 100), class)

sb_standings <- fread(sb_standings_csv, colClasses = column_class)

rm(column_class)

# First, I want to extract StartingQB from sb_standings
qb_list <- sb_standings[, StartingQB]

# Now, the column has multiple names per row. I want to know the max number of names in one row.
y <- c()
y <- lapply(qb_list, function(x) { length(strsplit(x, ", ")[[1]])})
y <- unlist(y)
maxY <- max(y)

# So, we have a maximum of 4 names in one element. I'll split them up into new variables
sbqb <- sb_standings[, .(Rk, StartingQB, Tm)]

# We keep the original variable to make sure our script is accurate
sbqb <- separate(sbqb, StartingQB, c(paste0("QB", 1:4)), 
                       sep = ",", fill = "right")

# Now I unite all QB Columns back to one. D1 will be removed later
sbqb <- sbqb %>% gather(D1, QB, QB1:QB4)

# We have some NA's under value we can get rid of. 
sbqb <- sbqb[complete.cases(sbqb$QB),]

# Now I'll add a win/loss column
patt <- "([A-Za-z ']+).*?([0-9]{1})-([0-9]{1})."
sbqb <- sbqb %>% 
    group_by(QB) %>% 
    mutate(ProperName = trimws(sub(patt, "\\1", QB)),  
           Wins = as.integer(sub(patt, "\\2", QB)), 
           Losses = as.integer(sub(patt, "\\3", QB)))

# Now I want to put family name first, followed by given, comma-delimited
sbqb <- sbqb %>% 
    separate(ProperName, c("FirstName", "LastName"), sep = " ") %>% 
    unite(FamilyGivenName, LastName, FirstName, sep = ", ")

# At the end, I'll select the clean vars and rearrange a little
sbqb <- sbqb %>% 
    select(FamilyGivenName, Tm, Wins, Losses)

# Rename FamilyGivenName to Name
names(sbqb)[1] <- "Name"
# Rename Tm to Team
names(sbqb)[2] <- "Team"

# And I'll add a winning percentage (WP) then order by Name
sbqb <- sbqb %>% 
    group_by(Name, Team) %>% 
    mutate(WP = as.numeric(sprintf("%0.3f", Wins/sum(Wins, Losses)))) %>% 
    arrange(Name)

# Lastly, save the dataset
sbqb_csv <- "./data/sports/football/sbqb.csv"
write.csv(sbqb, sbqb_csv, quote = c(1), row.names = FALSE)
