library(XML)
library(httr)
library(data.table)

url <- "http://www.pro-football-reference.com/play-index/draft-finder.cgi"

draft <- data.frame()

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
            row <- data.frame(Rk = td[1], 
                              Year = td[2], 
                              Rnd = td[3], 
                              Pick = td[4], 
                              Name = td[5], 
                              Pos = td[6], 
                              DrAge = td[7], 
                              Tm = td[8], 
                              From = td[9], 
                              To = td[10], 
                              AP1 = td[11], 
                              PB = td[12], 
                              St = td[13], 
                              CarAV = td[14], 
                              G = td[15], 
                              GS = td[16], 
                              QBrec = td[17], 
                              Cmp = td[18], 
                              PAtt = td[19], 
                              PYds = td[20], 
                              PTD = td[21], 
                              Int = td[22], 
                              RAtt = td[23], 
                              RYds = td[24], 
                              RTD = td[25], 
                              College = td[26])
            l <- list(draft, row)
            draft <- rbindlist(l, use.names = TRUE, fill = TRUE)
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

saveRDS(draft, paste(football_dir, "draft.rds", sep = "/"))
