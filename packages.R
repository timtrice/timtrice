# rrricanes dependencies
install.packages(c("data.table",
                   "dplyr",
                   "devtools",
                   "DBI",
                   "HURDAT",
                   "ggplot2",
                   "ggrepel",
                   "knitr",
                   "lubridate",
                   "purrr",
                   "readxl",
                   "rmarkdown",
                   "rnaturalearthdata",
                   "sp",
                   "stringr",
                   "tibble",
                   "tidyr",
                   "xml2"))

# GitHub packages
devtools::install_github("rstats-db/RMariaDB", build_vignettes = TRUE)
devtools::install_github("rstudio/blogdown", build_vignettes = TRUE)

# Drat
install.packages("rrricanesdata",
                 repos = "https://timtrice.github.io/drat/",
                 type = "source")
