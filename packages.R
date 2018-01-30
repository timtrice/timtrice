## ---- CRAN (MRAN) packages ----

install.packages(c("blogdown",
                   "data.table",
                   "dbplyr",
                   "dplyr",
                   "devtools",
                   "HURDAT",
                   "ggplot2",
                   "ggrepel",
                   "knitr",
                   "lubridate",
                   "pander",
                   "purrr",
                   "readxl",
                   "rmarkdown",
                   "rnaturalearthdata",
                   "sp",
                   "stringr",
                   "tibble",
                   "tidyr",
                   "xml2"))

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
