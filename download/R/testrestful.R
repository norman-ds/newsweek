source('R/restful.R', local = T)
source('R/config.R', local = T)
config_all <- build_config()

apifile <- 'rest/api.json'
apinames <-  c('display_name','created','download_url','filename','format','start_date','end_date')
apioj <- restful(apifile, apinames)

servicefile <- basename(config_all$filepath('swissdata'))

apispec <- c(config_all$data$title,
             config_all$data$date,
             servicefile,
             servicefile,
             unlist(strsplit(servicefile,'[.]'))[-1],
             '2019',
             '2021'
             )
names(apispec) <- apinames
apioj$init(pivot_wider(enframe(apispec)))
apioj$get()
apioj$write()
