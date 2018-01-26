# set a CRAN mirror
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://mran.microsoft.com/snapshot/2017-01-01"
  r["rrricanesdata"] <- "https://timtrice.github.io/drat/"
  options(repos = r)
})

options(warnPartialMatchArgs = TRUE, warnPartialMatchDollar = TRUE,
        warnPartialMatchAttr = TRUE)

# test for Windows
# test for Ubuntu
# test from Docker
