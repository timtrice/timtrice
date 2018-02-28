#' Test database connections
library(DBI)

#' MariaDB
library(RMariaDB)

host <- Sys.getenv("mariadb.host")
user <- Sys.getenv("mariadb.user")
password <- Sys.getenv("mariadb.password")

con <- dbConnect(RMariaDB::MariaDB(),
                 host = host,
                 username = user,
                 password = password)

dbDisconnect(con)

# Microsoft Server 2017
con <- DBI::dbConnect(odbc::odbc(),
                      driver = Sys.getenv("mssql.driver"),
                      database = "test_db",
                      uid = Sys.getenv("mssql.uid"),
                      pwd = Sys.getenv("mssql.password"),
                      server = Sys.getenv("mssql.host"),
                      port = Sys.getenv("mssql.ip"))

DBI::dbDisconnect(con)


#' MySQL
library(RMySQL)

host <- Sys.getenv("mysql.host")
user <- Sys.getenv("mysql.user")
password <- Sys.getenv("mysql.password")

con <- dbConnect(RMySQL::MySQL(),
                 host = host,
                 username = user,
                 password = password)

dbDisconnect(con)

#' Postgres
library(RPostgreSQL)

host <- Sys.getenv("postgres.host")
user <- Sys.getenv("postgres.user")
password <- Sys.getenv("postgres.password")

con <- dbConnect(RPostgreSQL::PostgreSQL(),
                 host = host,
                 user = user,
                 password = password)

dbDisconnect(con)
