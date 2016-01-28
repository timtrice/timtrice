library(data.table)
library(XML)
library(httr)
library(tidyr)

sbqb <- data.frame()

qbsrc <- "http://www.pro-football-reference.com/super-bowl/standings.htm#standings::none"

html <- GET(qbsrc)

content = content(html, as = "text")

parsed_html = htmlParse(content, asText = TRUE)

tr <- xpathSApply(parsed_html, "//tr", xmlValue)

for(i in tr[2:length(tr)]) { # Skip the header row
    
    parsed_html = htmlParse(i, asText = TRUE)
    
    values <- strsplit(i, "\n")
    
    this_td <- data.frame(Rk = trimws(values[[1]][1]), 
                          Tm = trimws(values[[1]][2]), 
                          G = trimws(values[[1]][3]), 
                          W = trimws(values[[1]][4]), 
                          L = trimws(values[[1]][5]), 
                          WLP = trimws(values[[1]][6]), #W-L% 
                          PF = trimws(values[[1]][7]), 
                          PA = trimws(values[[1]][8]), 
                          PD = trimws(trimws(values[[1]][9])), 
                          StartingQB = trimws(values[[1]][10]))
    clist <- list(sbqb, this_td)
    
    sbqb <- rbindlist(clist, use.names = TRUE, fill = TRUE)
    
}

football_dir <- "./data/sports/football"

if(!dir.exists(football_dir)) {
    dir.create(football_dir, recursive = TRUE)
}

write.csv(sbqb, paste(football_dir, "sbqb.csv", sep = "/"), quote = c(10), 
          row.names = FALSE)
