FROM rocker/verse:3.6.3

# Install R packages
## flexdashboard
RUN R -e "install.packages('flexdashboard', repos='https://cran.rstudio.com/')"
## plotly
RUN R -e "install.packages('plotly', repos='https://cran.rstudio.com/')"
## DT
RUN R -e "install.packages('DT', repos='https://cran.rstudio.com/')"

