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
    
    this_td <- data.frame(Rk = as.integer(trimws(values[[1]][1])), 
                          Tm = as.factor(trimws(values[[1]][2])), 
                          G = as.integer(trimws(values[[1]][3])), 
                          W = as.integer(trimws(values[[1]][4])), 
                          L = as.integer(trimws(values[[1]][5])), 
                          WLP = as.numeric(trimws(values[[1]][6])), #W-L% 
                          PF = as.integer(trimws(values[[1]][7])), 
                          PA = as.integer(trimws(values[[1]][8])), 
                          PD = I(trimws(trimws(values[[1]][9]))), 
                          StartingQB = I(trimws(values[[1]][10])))
    clist <- list(sbqb, this_td)
    
    sbqb <- rbindlist(clist, use.names = TRUE, fill = TRUE)
    
}

# Drop Rk
sbqb <- sbqb[, Rk := NULL]

football_dir <- "./data/sports/football"

if(!dir.exists(football_dir)) {
    dir.create(football_dir, recursive = TRUE)
}

saveRDS(sbqb, paste(football_dir, "sbqb.rds", sep = "/"))
