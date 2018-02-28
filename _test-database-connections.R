#' MariaDB
con <- dbConnect(RMariaDB::MariaDB(),
                 host = Sys.getenv("mariadb.host"),
                 username = Sys.getenv("mariadb.user"),
                 password = Sys.getenv("mariadb.password"))

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
con <- dbConnect(RMySQL::MySQL(),
                 host = Sys.getenv("mysql.host"),
                 username = Sys.getenv("mysql.user"),
                 password = Sys.getenv("mysql.password"))

dbDisconnect(con)

#' Postgres
con <- dbConnect(RPostgreSQL::PostgreSQL(),
                 host = Sys.getenv("postgres.host"),
                 user = Sys.getenv("postgres.user"),
                 password = Sys.getenv("postgres.password"))

dbDisconnect(con)
