Overview
========
This is the iGEM42 tool, developed by the iGEM Team Heidelberg during iGEM 2013. It is capable of collecting, condensing and displaying data on the past igem years.

Directory structure
-------------------
* __web/__: contains the web interface, written in R using the shiny and rCharts packages.
* __scraper/__: contains the scraping and text mining scripts written in python.
* __analysis__/: contains the R script analysing and converting the generated data.

Python stuff
============
These Python packages can be installed with pip by running
`pip install package`
If you are on Mac OS X or Linux, you need to run this as root:
`sudo pip install package`

Main packages
--------------
* __Python__ (2.7)
* __...__

Other stuff that is loaded by some of our python functions:
-----------------------------------------------------------
* __Requests__:Great library to do simple http requests!
* __RabbitMQ__: Message broker required by Celery
* __Biopython__ (>= 1.62): Just like bioperl but not in a crappy language!
* __xhtml2pdf__: Also necessary for Gibthon..
* __BeautifulSoup__: Beautiful soup!
* __celery__: asynchronous scheduling framework
* __kombu__: database-based message passing framework
* __python-openbabel__: (>= 2.3.2) Python bindings to openbabel for 2D structure generation
* __UNAFold__ and __MFold utils__: required by Gibthon
* __HMMER__ (= 3.0): Hidden Markov Model based sequence analysis software used by antiSMASH
* __MUSCLE__: multiple sequence alignment used by antiSMASH
* __Clustal Omega__: multiple sequence alignment used by NRPSDesigner
* __libSBOLpy__: Python bindings to the libSBOLc library

R stuff
=======
All R packages, including the base distribution are accessible on http://cran.r-project.org/.

* __base distribution__: basic R environment
* __shiny__: generating R compatible web applications
* __rCharts__: generating elaborate graphs and graphics
* __devtools__: required for installing rCharts
* __RJSONIO__: needed for data conversion from JSON to R

Web integration
---------------
To integrate the apps in a different homepage include an iframe to display the app from corresponding folder. The minimum folders needed are:
* __web/apps__
* __web/data__