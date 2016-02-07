#' Drafted Quartebacks courtesy of Pro-Football-Reference.com
#' 
#' Please read Sports Reference LLC's Use of Data terms before operating this 
#' script
#' 
#' http://www.sports-reference.com/data_use.shtml
#' 
#' This script access the site and loops through all pages of data, retrieving
#' the tables on each page. Tables are then parsed and loaded into a dataframe 
#' for further parsing. 
#' 
#' At this time I do not know all of the parameters. Visit the page and explore 
#' the url for the specific params. 
#' 

#' Set our variables
url <- "http://www.pro-football-reference.com/play-index/draft-finder.cgi"

#' Dir to save data and name of csv file to save
data_dir <- "./data/sports/football"
csv_filename <- "draft-qb.csv"

#' URL Parameters
url_params <- list(request = 1, 
                   year_min = 1936, # Starting year
                   year_max = 2015, # Ending year 
                   year_only = "", 
                   type = "B",  # Regular draft and supplemental draft
                   round_min = 1, 
                   round_max = 30, 
                   slot_min = 1, 
                   slot_max = 500, # Maxium draft slot
                   league_id = "", # NFL, AFL or AAFC
                   team_id = "", # Team
                   college_id = "all", 
                   conference = "any", 
                   show = "all", 
                   order_by = "", 
                   order_by_asc = "DESC", 
                   mobile = 0, 
                   pos_new = "qb", 
                   offset = 0)

#' Load our libraries
library(XML)
library(httr)
library(data.table)

#' Set the empty dataframe
draft_qb <- data.frame()

while(TRUE) {

    query_string <- paste0(paste(names(url_params), 
                                 url_params, sep = "="), 
                           collapse = "&")
    
    query_url <- paste(url, query_string, sep = "?")
    
    html <- GET(query_url)
    
    content = content(html, as = "text")
    
    # in some instances there are two spaces between tr and class
    pattern <- "<tr[ ]+class=\"\">.*?</tr>"
    
    matches <- gregexpr(pattern, content)

    # Each tr will be a row in our dataframe except the first(header)
    tr <- regmatches(content, matches)[[1]]
    
    td <- lapply(tr, htmlParse, asText = TRUE)
    
    trow <- lapply(td, xpathSApply, "//td", xmlValue)
    
    trow <- trow[-1]
    
    trow <- as.data.frame(t(as.data.frame(trow)))
    
    qbl <- list(draft_qb, trow)
    
    draft_qb <- rbindlist(qbl)

    if(length(tr) < 301) {
        message("End of data")
        break # We have no more 
    } else {
        url_params$offset <- url_params$offset + 300
    }
}

# Drop the Rnk var
draft_qb <- draft_qb[, .(V1, V27) := NULL]

qdb_names <- c("Year", "Rnd", "Pick", "Name", "Pos", "DrAge", "Tm", "From", 
               "To", "AP1", "PB", "St", "CarAV", "G", "GS", "QBrec", "Cmp", 
               "PAtt", "PYds", "PTD", "Int", "RAtt", "RYds", "RTD", "College")

names(draft_qb) <- qdb_names

#' Write the CSV
write.csv(draft_qb, paste(data_dir, csv_filename, sep = "/"), quote = FALSE, 
          row.names = FALSE)
