FROM rocker/tidyverse:3.4.3

# Update system software
RUN apt-get update \
  && apt-get install -y \
    # For rrricanes
    libgdal-dev \
    libproj-dev \
    # For the littler R package
    r-cran-littler \
    # These next two are for XLConnect (a dependency of tidyquant)
    openjdk-8-jdk \
    # Database drivers
    unixodbc  \
    unixodbc-dev \
    tdsodbc \
    odbc-postgresql \
    libsqliteodbc \
    # Needed to add the Microsoft sources below.
    apt-transport-https \
    # This is for me.
    vim \
    curl \
    # For MS SQL Server \ need to install ODBC 13 Driver (17 not avail as of now).
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install msodbcsql \
  # Set java conf
  && R CMD javareconf \
  && install2.r -e \
    blogdown \
    corrplot \
    ggrepel \
    HURDAT \
    miniUI \
    packrat \
    pander \
    PKI \
    RCurl \
    RJSONIO \
    rnaturalearthdata \
    rsconnect \
    skimr \
    sweep \
    tibbletime \
    tidyquant \
    timetk \
  && install2.r -e -r https://timtrice.github.io/drat/ \
    rrricanesdata \
  && installGithub.r \
    r-dbi/DBI@v0.7-12 \
    r-dbi/odbc@v1.1.1 \
    r-dbi/RMariaDB@v1.0-2 \
    r-dbi/RPostgres@v0.1-6 \
    ropensci/rrricanes@v0.2.0-6 \
    timtrice/NCDCStormEvents \
    yihui/xfun@v0.1 \
  && echo "\n# set CRAN mirrors \
    \noptions(c(getOption('repos'), 'https://timtrice.github.io/drat/'), \
    \n\t\t\t\tblogdown.hugo.dir = '/home/rstudio/bin/', \
    \n\t\t\t\twarnPartialMatchArgs = TRUE,  \
    \n\t\t\t\twarnPartialMatchDollar = TRUE, \
    \n\t\t\t\twarnPartialMatchAttr = TRUE) \
    \n" >> /usr/local/lib/R/etc/Rprofile.site \
  && R -e "blogdown::install_hugo()" \
  && mkdir -p /home/rstudio/.rstudio/monitored/user-settings \
  && git config --global user.email "tim.trice@gmail.com" \
  && git config --global user.name "Tim Trice"

COPY user-settings /home/rstudio/.rstudio/monitored/user-settings/
RUN chown -R rstudio:rstudio /home/rstudio/.rstudio
