library(tidyverse)
library(jsonlite)

build_site <- function() {
  source('R/config.R', local = T)
  source('R/build.R', local = T)
  source('R/content.R', local = T)
  
  config_all <- build_config()
  anybox <- ranybox(start=writedate())
  
  config <- config_all$data$build
  build_build()
  

  config <- config_all$data$content
  public <- build_config()$tmpdir()
  public$add(config_all$filepath('swissdata'))
  public$add(config_all$filepath('restfile'))
  public$add(config_all$filepath('staticlog'))
  build_content(public$path)
  public$dopublic()

  invisible(anybox$get())
}

# date as string function
writedate <- function(datetime=Sys.time()) {
  format(datetime, yaml::read_yaml('config.yaml')$dateformat)
}

# a message box function
ranybox <- function(...) {
  
  mylist <- list(...)
  
  get <- function() {
    mylist
  }
  
  add <- function(...) {
    #mylist <<- list(...)
    mylist <<- append(mylist, list(...))
  }
  
  return(list(get=get, add=add))
}

build_site()

