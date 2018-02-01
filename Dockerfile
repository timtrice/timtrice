FROM rocker/tidyverse:3.4.3

RUN apt-get update \ 
  && apt-get install -y \ 
    libgdal-dev \ 
    libproj-dev \
    r-cran-littler

WORKDIR /home/rstudio

COPY .Rprofile .

ADD setup.R . 

RUN Rscript setup.R

