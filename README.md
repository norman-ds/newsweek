
<!-- README.md is generated from README.Rmd. Please edit that file  -->

# World’s Best Hospitals 2021

This is the third year that Newsweek has partnered with Statista Inc,
the respected global data research firm, to reveal the World’s Best
Hospitals— and it may be our most important ranking yet.

### DevOps

RStudio’s IDE is launched in a Docker and accessed through the browser
(<http://localhost:8787>).

``` yaml
docker run --name newsweek -d -p 8787:8787 -v $(pwd):/home/rstudio -e PASSWORD=pwd rocker/verse:3.6.3
```

The Docker image from *rocker/verse* has R version 3.6.3 and some
packages installed, saving us from having to reinstall.

``` r
sessionInfo()
#> R version 3.6.3 (2020-02-29)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Debian GNU/Linux 10 (buster)
#> 
#> Matrix products: default
#> BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/libopenblasp-r0.3.5.so
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C             
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_3.6.3  magrittr_1.5    tools_3.6.3     htmltools_0.4.0
#>  [5] yaml_2.2.1      Rcpp_1.0.4.6    stringi_1.4.6   rmarkdown_2.1  
#>  [9] knitr_1.28      stringr_1.4.0   xfun_0.13       digest_0.6.25  
#> [13] rlang_0.4.5     evaluate_0.14
```

The version list of the used R
packages.

``` r
libs <- c("RCurl","curl","readr","dplyr","purrr","ggplot2","flexdashboard","DT","plotly")
ip <- installed.packages(fields = c("Package", "Version"))
ip <- ip[ip[,c("Package")] %in% libs,]
paste(ip[,c("Package")],ip[,c("Version")])
#> [1] "curl 4.3"              "dplyr 0.8.5"           "DT 0.13"              
#> [4] "flexdashboard 0.5.1.1" "ggplot2 3.3.0"         "plotly 4.9.2.1"       
#> [7] "purrr 0.3.4"           "RCurl 1.98-1.2"        "readr 1.3.1"
```
