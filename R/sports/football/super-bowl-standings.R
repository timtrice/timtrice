library(data.table)
library(XML)
library(httr)
library(tidyr)

qbsrc <- "http://www.pro-football-reference.com/super-bowl/standings.htm#standings::none"

data_dir <- "./data/sports/football"

csv_filename <- "sb-standings.csv"

html <- GET(qbsrc)

content = content(html, as = "text")

td <- lapply(content, htmlParse, asText = TRUE)

sbs <- lapply(td, xpathSApply, "//tr", xmlValue)

sbs <- lapply(sbs, strsplit, "\n")

sbs <- t(as.data.frame(sbs[[1]][-1]))

sbs <- as.data.table(sbs)

sbs <- sbs[, V1 := NULL]

sbs_names <- c("Tm", "G", "W", "L", "WLP", "PF", "PA", "PD", "StartingQB")

names(sbs) <- sbs_names

sbs <- lapply(sbs, function(x){ trimws(x) })

if(!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
}

write.csv(sbs, paste(data_dir, csv_filename, sep = "/"), quote = c(9), 
          row.names = FALSE)
