raw_atlantic <- "http://www.nhc.noaa.gov/data/hurdat/hurdat2-1851-2014-060415.txt"
raw_epac <- "http://www.nhc.noaa.gov/data/hurdat/hurdat2-nencpac-1949-2014-092515.txt"

library(data.table)

colClasses <- sapply(read.csv(raw_atlantic, nrows = 1000, header = FALSE), class)

# Read in files
al <- read.csv(raw_atlantic, header = FALSE, stringsAsFactors = FALSE, 
               na.strings = c(-999, -99, 0, " ", "  "), colClasses = colClasses)

ep <- read.csv(raw_epac, header = FALSE, stringsAsFactors = FALSE, 
               na.strings = c(-999, -99, 0, " ", "  "), colClasses = colClasses)

datasets <- list(al, ep)

# Bind datasets to one
dt <- rbindlist(datasets)

colNames <- c("StormID", "Time", "Record", "Status", "Latitude", 
               "Longitude", "Wind", "Pressure", "WindRadii34NE", 
               "WindRadii34SE", "WindRadii34SW", "WindRadii34NW", 
               "WindRadii50NE", "WindRadii50SE", "WindRadii50SW", 
               "WindRadii50NW", "WindRadii64NE", "WindRadii64SE", 
               "WindRadii64SW", "WindRadii64NW", "ID")

# Assign column names
names(dt) <- colNames

# Populate the empty ID var with a true ID or Key
dt$ID <- seq(1:nrow(dt))

setkey(dt, ID)

# Extract all header rows
header_pattern <- "^[AL]|[EP]|[CP]"
headers <- dt[grep(pattern = header_pattern, dt[, StormID]), 
              .(ID, StormID, Time, Record)]

# Rename Time to Name and Record to Lines
colnames(headers)[3:4] <- c("Name", "Lines")

setkey(headers, ID)

# Join the two datasets back together
dt <- headers[dt, roll = TRUE]

# Where were our header rows located?
row_headers <- grep(pattern = header_pattern, dt$i.StormID)

# Strip the header rows
dt <- dt[-c(row_headers),]

# Save
write.csv(dt, file = "./data/weather/HURDAT/hurdat.raw.csv", quote = FALSE, 
          row.names = FALSE)

# And we're done
