library(ggplot2)
library(data.table)
library(xtable)

# Import datasets
draft_qb_csv <- "./data/sports/football/draft_qb.csv"

sbqb_csv <- "./data/sports/football/sbqb.csv"

# Get column classes for draft_qb
column_class = sapply(read.csv(draft_qb_csv, nrows = 100), class)

draft_qb <- fread(draft_qb_csv, colClasses = column_class)

rm(column_class)

# Get column classes for sbqb
column_class = sapply(read.csv(sbqb_csv, nrows = 100), class)

sbqb <- fread(sbqb_csv, colClasses = column_class)

rm(column_class)

str(draft_qb)

str(sbqb)

# Create a new data table starting with Name, College, Rnd and Pick
dt <- draft_qb[, .(Name, College, Year, Rnd, Pick, Tm)]

# Switch name around so family name is first followed by given
dt <- dt[, ':=' (LastName = strsplit(Name, " ")[[1]][2], 
                 FirstName = strsplit(Name, " ")[[1]][1]), 
         by = Name
         ][, FullName := paste(LastName, FirstName, sep = ", ")]

# Drop Name, LastName, FirstName
dt <- dt[, c("Name", "LastName", "FirstName") := NULL]

setkey(dt, FullName)
setkey(sbqb, Name)

draft <- merge(sbqb, dt, by.x = "Name", by.y = "FullName")

draft <- draft[, .(Name, Team, Tm, College, Year, Rnd, Pick, Wins, Losses, WP)]

# I tend to be anal about column order...

# Don't need these anymore...
rm(sbqb, draft_qb, dt)

# Lastly, save the dataset
draft_csv <- "./data/sports/football/drafted-qb-super-bowl.csv"
write.csv(draft, draft_csv, quote = c(1, 2, 4), row.names = FALSE)
