library(tidyverse)
#library(RCurl)
#library(xml2)
#library(rvest)

webpage_url <- 'https://www.newsweek.com'
countries <- c('Switzerland','USA','Canada','Germany','Austria','France')

##################### COUNTRYTABLE ##################### 

# create a table with the participating countries
countrytable <- set_names(2019:2021) %>%
  purrr::map_dfr( function(x) {
    nd <- xml2::read_html(str_c('https://www.newsweek.com/best-hospitals-',x)) %>% 
          # this get the dropdown menu 
          rvest::html_nodes("article") %>%
          # the list
          rvest::html_nodes("ul li a") 
   return(tibble(text = rvest::html_text(nd, T),
                 link = rvest::html_attr(nd,'href')))
    },.id = 'year') 

countrytable <- countrytable %>%
  mutate(text2 = str_replace_all(text, "[^[A-Za-z]]", " ")) %>%
  mutate(text2 = str_replace_all(text2, "Best Hospitals", " ")) %>%
  mutate(text2 = str_squish(text2)) %>%
  mutate(country = if_else(!grepl('Top', text2), text2, '')) %>%
  mutate(country = case_when(country == 'United States' ~ 'USA',
                             TRUE ~ country))

countrytable$url <- str_c(webpage_url,countrytable$link)

# check the table
dim(countrytable) # [1] 63  6
count(countrytable, country)
count(countrytable, year)

# write the country table to the disc
select(countrytable, year, text, country, url) %>%
  write_csv('static/nw_countries.csv')



##################### HOSPITALS ##################### 

# get the participating hispitals 
countrytable <- countrytable %>%
  filter(country %in% countries) %>% # 16 records
  mutate(life = RCurl::url.exists(url))
stopifnot(all(countrytable$life))

# function to read all the tables
gethosp19 <- function(wpurl) {
  tlist <- xml2::read_html(wpurl) %>%
    rvest::html_table() 
  tlist[[1]] %>%
    tibble::as_tibble(.name_repair = "unique") # repair the repeated columns
}


### DIFFERENT TABLES !!!

# list of countries in year 2021
listhosp21 <- countrytable %>%
  filter(year == "2021") %>%
  pull(url) %>%
  map(gethosp19)
names(listhosp21) <- countrytable$country[countrytable$year=='2021']
map(listhosp21, head,3)

# list of countries in year 2020
listhosp20 <- countrytable %>%
  filter(year == "2020") %>%
  pull(url) %>%
  map(gethosp19)
names(listhosp20) <- countrytable$country[countrytable$year=='2020']
map(listhosp20, head,3)

# list of countries in year 2019
listhosp19 <- countrytable %>%
  filter(year == "2019") %>%
  pull(url) %>%
  map(gethosp19)
names(listhosp19) <- countrytable$country[countrytable$year=='2019']
map(listhosp19, head,3)


# create one table with the participating hospitals
table21 <- listhosp21 %>%
  map_dfr(~ select(.x, Countryrank=1, Hospital, Score, City) %>%
            mutate(Year=2021L), .id = 'Country') %>%
  mutate(Score = str_replace_all(Score, "[^[0-9.]]", "") %>% as.double())
table20 <- listhosp20 %>%
  map_dfr(~ select(.x, Countryrank=1, Hospital, Score, City) %>%
            mutate(Year=2020L), .id = 'Country')%>%
  mutate(Score = str_replace_all(Score, "[^[0-9.]]", "") %>% as.double())
table19 <- listhosp19 %>%
  map_dfr(~ select(.x, Countryrank=1, Hospital, Score, City) %>%
            mutate(Year=2019L), .id = 'Country')

bind_rows(table21,table20,table19) %>%
  write_csv('static/nw_hospitals.csv')

