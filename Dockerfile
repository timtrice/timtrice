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
    # This is for me. 
    vim

# Set java conf
RUN R CMD javareconf

# Create working directory for image user
WORKDIR /home/rstudio

# Rstudio .Rprofile
COPY .Rprofile .

# Install R packages, other R configurations
ADD setup.R . 
RUN Rscript setup.R

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
 
