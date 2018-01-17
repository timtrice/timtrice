library(DBI)
library(RMySQL)

data(list = data(package = "rrricanesdata")$results[,3],
     package = "rrricanesdata")

host <- Sys.getenv("mysql.host")
user <- Sys.getenv("mysql.user")
password <- Sys.getenv("mysql.password")

con <- dbConnect(RMySQL::MySQL(), host = host, user = user, password = password)

dbSendQuery(con, "CREATE DATABASE IF NOT EXISTS rrricanesdata")

dbSendQuery(con, "USE rrricanesdata")

dbWriteTable(con, "discus", as.data.frame(discus), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "fstadv", as.data.frame(fstadv), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "posest", as.data.frame(posest), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "prblty", as.data.frame(prblty), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "public", as.data.frame(public), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "update", as.data.frame(update), overwrite = TRUE, row.names = FALSE)
dbWriteTable(con, "wndprb", as.data.frame(wndprb), overwrite = TRUE, row.names = FALSE)

dbDisconnect(con)
