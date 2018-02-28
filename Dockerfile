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
    curl

# For MS SQL Server, need to install ODBC 13 Driver (17 not avail as of now).
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \ 
  && curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list \ 
  && apt-get update \ 
  && ACCEPT_EULA=Y apt-get install msodbcsql

# Set java conf
RUN R CMD javareconf

WORKDIR /home/rstudio

RUN wget https://raw.githubusercontent.com/timtrice/web/master/.Rprofile \ 
  && wget https://raw.githubusercontent.com/timtrice/web/master/_install.R \ 
  && Rscript "_install.R"

RUN rm .Rprofile \ 
  && rm _install.R

RUN mkdir -p .rstudio/monitored/user-settings

WORKDIR /home/rstudio/.rstudio/monitored/user-settings

RUN wget https://gist.githubusercontent.com/timtrice/94a679b51388faf99ef7918c7bdaff8d/raw/9a52ffebd1e2e8587918a31ff8e962110b816936/user-settings

WORKDIR /home/rstudio

RUN chown -R rstudio:rstudio .

