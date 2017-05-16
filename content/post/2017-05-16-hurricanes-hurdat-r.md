---
title: "Introducing Hurricanes, HURDAT"
date: 2017-05-16T10:47:00-05:00
author: "Tim Trice"
tags: ["R", "Hurricanes", "HURDAT"]
---

I'm proud to introduce two new packages for the R community: __HURDAT__ and ___Hurricanes___. 

Both packages are complimentary to one another. 

[HURDAT](http://timtrice.net/projects/hurdat/) is a dataset of tropical cyclones that have developed in the Atlantic and northeast Pacific oceans since 1851 and 1949, respectively. ___HURDAT___ is a re-analysis project as conducated by the Hurricane Research Division of the National Oceanic and Atmospheric Administration. They review known data to determine the best track, intensity and structure of a cyclone. 

This is a great dataset to work with:

* Climatology

* Relationship between wind/pressure.

* Hurricanes by landfall location

* [ACE](https://en.wikipedia.org/wiki/Accumulated_cyclone_energy)

* Largest and smallest (by wind radius).

The [HURDAT](http://www.aoml.noaa.gov/hrd/hurdat/Data_Storm.html) project homepage has some other ideas that can be extracted from this data. 

___HURDAT___ is available on [CRAN](https://cran.r-project.org/web/packages/HURDAT/index.html) for R >= 3.4.0.

```r
install.packages("HURDAT")
```

After loading ___HURDAT___ take a look at the vignette.

```r
vignette("hurdat", package = "HURDAT")
```

[Hurricanes](/projects/hurricanes/) gathers more comprehensive data for Atlantic and northeast Pacific tropical cyclones. However, this data currently only goes back to 1998. It does include real-time data for active cyclones.

___Hurricanes___ provides details on the current position and structure of the storm as well as forecast positions. Additionally, technical and public discussions, if available, can be retrieved from the package. 

___Hurricanes___ is not currently available in CRAN. Please consider it a beta release. Install the package with:

```r
devtools::install_github("timtrice/Hurricanes")
```

After loading the library, take a look at the "Getting Started" vignette:

```r
vignette("getting-started", package = "Hurricanes")
```
