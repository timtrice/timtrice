# set CRAN mirrors
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://mran.microsoft.com/snapshot/2018-01-01"
  r["rrricanesdata"] <- "https://timtrice.github.io/drat/"
  options(repos = r)
})

options(warnPartialMatchArgs = TRUE, warnPartialMatchDollar = TRUE,
        warnPartialMatchAttr = TRUE)
