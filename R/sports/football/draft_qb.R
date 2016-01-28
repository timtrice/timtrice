library(XML)
library(httr)
library(data.table)

url <- "http://www.pro-football-reference.com/play-index/draft-finder.cgi"

draft_qb <- data.frame()

offset <- 0
while(TRUE) {

    url_params <- list(request = 1, 
                       year_min = 1936, 
                       year_max = 2015, 
                       year_only = "", 
                       type = "B",  # Regular draft and supplemental draft
                       round_min = 1, 
                       round_max = 30, 
                       slot_min = 1, 
                       slot_max = 500, 
                       league_id = "", 
                       team_id = "", 
                       college_id = "all", 
                       conference = "any", 
                       show = "all", 
                       order_by = "", 
                       order_by_asc = "DESC", 
                       mobile = 0, 
                       pos_new = "qb", 
                       offset = offset)
    
    query_string <- paste0(paste(names(url_params), 
                                 url_params, sep = "="), 
                           collapse = "&")
    
    query_url <- paste(url, query_string, sep = "?")
    
    html <- GET(query_url)
    
    content = content(html, as = "text")
    
    # in some instances there are two spaces between tr and class
    pattern <- "<tr[ ]+class=\"\">.*?</tr>"
    
    matches <- gregexpr(pattern, content)

    # Each tr will be a row in our dataframe but
    tr <- regmatches(content, matches)[[1]]

    for(n in tr) {
        parsedHtml = htmlParse(n, asText = TRUE)

        td <- xpathSApply(parsedHtml, "//td", xmlValue)
    
        if(length(td) > 0) {
            row <- data.frame(Rk = trimws(td[1]), 
                              Year = trimws(td[2]),  
                              Rnd = trimws(td[3]), 
                              Pick = trimws(td[4]), 
                              Name = trimws(td[5]), 
                              Pos = trimws(td[6]), 
                              DrAge = trimws(td[7]), 
                              Tm = trimws(td[8]), 
                              From = trimws(td[9]), 
                              To = trimws(td[10]), 
                              AP1 = trimws(td[11]), 
                              PB = trimws(td[12]), 
                              St = trimws(td[13]), 
                              CarAV = trimws(td[14]), 
                              G = trimws(td[15]), 
                              GS = trimws(td[16]), 
                              QBrec = trimws(td[17]), 
                              Cmp = trimws(td[18]), 
                              PAtt = trimws(td[19]), 
                              PYds = trimws(td[20]), 
                              PTD = trimws(td[21]), 
                              Int = trimws(td[22]), 
                              RAtt = trimws(td[23]), 
                              RYds = trimws(td[24]), 
                              RTD = trimws(td[25]), 
                              College = trimws(td[26]))

            l <- list(draft_qb, row)

            draft_qb <- rbindlist(l, use.names = TRUE, fill = TRUE)
        }
    
    }


    if(length(tr) < 300) {
        message("End of data")
        break # We have no more 
    } else {
        offset <- offset + 300
    }
}

football_dir <- "./data/sports/football"

if(!dir.exists(football_dir)) {
    dir.create(football_dir, recursive = TRUE)
}

write.csv(draft_qb, paste(football_dir, "draft_qb.csv", sep = "/"), 
          row.names = FALSE)
