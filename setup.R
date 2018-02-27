# set CRAN mirrors
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://mran.microsoft.com/snapshot/2018-01-01"
  r["rrricanesdata"] <- "https://timtrice.github.io/drat/"
  options(repos = r)
})

options(warnPartialMatchArgs = TRUE, warnPartialMatchDollar = TRUE,
        warnPartialMatchAttr = TRUE)


update.packages(ask = FALSE)

## ---- CRAN (MRAN) packages ----

install.packages(c("blogdown",
                   "corrplot", 
                   "data.table",
                   "ggrepel",
                   "Hmisc",
                   "HURDAT",
                   "knitr",
                   "lubridate",
                   "miniUI",
                   "packrat",
                   "pander",
                   "PKI",
                   "RCurl",
                   "RJSONIO", 
                   "rmarkdown",
                   "rnaturalearthdata",
                   "rsconnect",
                   "skimr",
                   "sp", 
                   "sweep", 
                   "tibbletime", 
                   "tidyquant", 
                   "timetk"))

## ---- GitHub packages ----

# DBI 0.7-12 is required for RMariaDB
devtools::install_github("r-dbi/DBI", ref = "v0.7-12",
                         build_vignettes = TRUE)

devtools::install_github("r-dbi/RMariaDB", ref = "v1.0-2",
                         build_vignettes = TRUE)

devtools::install_github("r-dbi/RMySQL", ref = "v0.10.13",
                         build_vignettes = TRUE)

devtools::install_github("r-dbi/RPostgres", ref = "v0.1-6",
                         build_vignettes = TRUE)

# See RSQLite on GitHub for additional install instructions:
# https://github.com/r-dbi/RSQLite
devtools::install_github("rstats-db/RSQLite")

devtools::install_github("ropensci/rrricanes", ref = "v0.2.0-6")

## ---- Drat ----
install.packages("rrricanesdata",
                 repos = "https://timtrice.github.io/drat/",
                 type = "source")

blogdown::install_hugo()

