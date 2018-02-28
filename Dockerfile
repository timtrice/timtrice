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
    #This is needed to add the Microsoft sources below.
    apt-transport-https \
    # This is for me.
    vim \
    curl

# For MS SQL Server, need to install ODBC 13 Driver (17 not avail as of now).
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install msodbcsql

# Set java conf
RUN R CMD javareconf

# Create working directory for image user
WORKDIR /home/rstudio

# Rstudio .Rprofile
RUN wget https://raw.githubusercontent.com/timtrice/web/master/.Rprofile

# Install R packages, other R configurations
RUN wget https://raw.githubusercontent.com/timtrice/web/master/setup.R
RUN Rscript setup.R

RUN rm .Rprofile
RUN rm setup.R

# RStudio Server Global Options
RUN mkdir .rstudio
RUN mkdir .rstudio/monitored
RUN mkdir .rstudio/monitored/user-settings

WORKDIR /home/rstudio/.rstudio/monitored/user-settings
RUN wget https://gist.githubusercontent.com/timtrice/94a679b51388faf99ef7918c7bdaff8d/raw/9a52ffebd1e2e8587918a31ff8e962110b816936/user-settings
WORKDIR /home/rstudio
RUN chown -R rstudio:rstudio .rstudio

RUN echo $$\ $$\ $$\       $$$$$$$$\ $$$$$$\ $$\   $$\ $$$$$$\       $$\ $$\ $$\
RUN echo $$ |$$ |$$ |      $$  _____|\_$$  _|$$$\  $$ |\_$$  _|      $$ |$$ |$$ |
RUN echo $$ |$$ |$$ |      $$ |        $$ |  $$$$\ $$ |  $$ |        $$ |$$ |$$ |
RUN echo $$ |$$ |$$ |      $$$$$\      $$ |  $$ $$\$$ |  $$ |        $$ |$$ |$$ |
RUN echo \__|\__|\__|      $$  __|     $$ |  $$ \$$$$ |  $$ |        \__|\__|\__|
RUN echo                   $$ |        $$ |  $$ |\$$$ |  $$ |
RUN echo $$\ $$\ $$\       $$ |      $$$$$$\ $$ | \$$ |$$$$$$\       $$\ $$\ $$\
RUN echo \__|\__|\__|      \__|      \______|\__|  \__|\______|      \__|\__|\__|

