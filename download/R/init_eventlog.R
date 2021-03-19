library(tidyverse)
source('R/config.R', local = T)
config_all <- build_config()

# function timestamp to char
writedate <- function(datetime=Sys.time()) {
  format(datetime, config_all$data$dateformat)
}

# build initial eventlog dataframe
servicename <- str_c(config_all$data$servicename, ' service')
logdf <- tibble(source = servicename,
                activity = 'check-in',
                timestamp = writedate(),
                status = 'complete',
                resource = servicename
               )

# add some records to the dataframe
logdf <- map_df(config_all$data$events$entries, as_tibble) %>%
  arrange(desc(source)) %>%
  bind_rows(logdf) %>%
  select(names(logdf)) %>%
  filter(!is.null(source) & !is.na(source) & source != '') %>%
  mutate_all(~ if_else(is.na(.x), max(.x), .x))

logdf$activity[is.na(logdf$activity)] <- 'check-in'
logdf$timestamp[is.na(logdf$timestamp)] <- writedate()
logdf$status[is.na(logdf$status)] <- 'complete'
logdf$resource[is.na(logdf$resource)] <- servicename

# write the eventlog file
logfile <- config_all$filepath('staticlog')
write_csv(logdf, logfile)