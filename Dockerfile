FROM rocker/rstudio:3.4.0

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    vim \
    build-essential \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev  \
    libgdal-dev \
    libproj-dev \
    libxml2-dev

# Change default shell for user rstudio
RUN chsh -s /bin/bash rstudio

# Add working directory for proceeding commands
WORKDIR /home/rstudio

# Clone GitHub repo
RUN git clone https://github.com/timtrice/web.git

WORKDIR web

RUN git checkout develop

# Change ownership of all files to rstudio
RUN chown -R rstudio:rstudio .

RUN Rscript packages.R
