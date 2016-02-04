library(data.table)

hurdat <- "https://raw.githubusercontent.com/timtrice/datasets/master/weather/HURDAT/hurdat.raw.csv"

dt <- as.data.table(read.csv(hurdat, stringsAsFactors = FALSE))

# First thing I want to do is trim the whitespace around Name
dt <- dt[, Name := trimws(Name)]

# Trim Record
dt <- dt[, Record := trimws(Record)]

# Trim Status
dt <- dt[, Status := trimws(Status)]

# I can drop Lines
dt <- dt[, Lines := NULL]

# I'll rename i.StormID to Date
colnames(dt)[4] <- "Date"

# Latitude and Longitude can be cleaned. 
ifelse(substr(dt$Latitude, 6, 6) == "N",  
    dt$Latitude <- as.numeric(substr(dt$Latitude, 1, 5)),  
    dt$Latitude <- as.numeric(substr(dt$Latitude, 1, 5)) * -1) 

ifelse (substr(dt$Longitude, 7, 7) == "E",  
    dt$Longitude <- as.numeric(substr(dt$Longitude, 1, 6)),  
    dt$Longitude <- as.numeric(substr(dt$Longitude, 1, 6)) * -1) 

# All vars are now cleaned up pretty well. Time to do some tidyring
library(tidyr)

dt <- dt[, ":=" (Basin = substr(StormID, 0, 2), 
                    YearNum = as.numeric(substr(StormID, 3, 4)), 
                    Year = as.numeric(substr(StormID, 5, 8)))]

# Make a DateTime var off Year, Time. 
# Some ime fields are incomplete (i.e., "0", "600"); pad Time with leading 0's
library(lubridate)
library(stringr)

dt <- dt[, Datetime := ymd_hm(paste(Date, 
    str_pad(Time, 4, side = "left", pad = "0"), 
    sep = " "))]

# Redo ID due to stripping header rows in parse.R
dt <- dt[, ID := seq(1:nrow(dt))]

# Reorganize columns
dt <- dt[, .(ID, Basin, Name, YearNum, Datetime, Record, Status, Latitude, 
    Longitude, Wind, Pressure, WindRadii34NE, WindRadii34SE, WindRadii34SW, 
    WindRadii34NW, WindRadii50NE, WindRadii50SE, WindRadii50SW, 
    WindRadii50NW, WindRadii64NE, WindRadii64SE, WindRadii64SW, 
    WindRadii64NW)]

# Write csv
write.csv(dt, file = "./data/weather/HURDAT/hurdat.tidyr.csv", quote = FALSE, 
    row.names = FALSE)

# And we're done
