build_build <- function() {

  # output file
  swissdata <- config_all$filepath('swissdata')
  
  # load datafile
  nw_hospitals <- read_csv(config_all$filepath('hospitalfile'),
                           col_types = cols(Countryrank = col_integer(), 
                                            Year = col_character()))
  # TODO: do some text mining
  nw_hospitals %>%
    filter(Country == 'Switzerland') %>%
    mutate(kz = case_when(
      grepl('HUG', Hospital) ~ 'Les Hôpitaux Universitaires de Genève HUG, Cluse-Roseraie',
      grepl('Vaudois', Hospital) ~ 'Centre Hospitalier Universitaire Vaudois',
      grepl('Uni.*Zürich', Hospital) ~ 'Universitätsspital Zürich',
      grepl('Luzerner', Hospital) ~ 'Luzerner Kantonsspital',
      grepl('Gallen', Hospital) ~ 'Kantonsspital St.Gallen',
      grepl('Beau.*Site', Hospital) ~ 'Hirslanden Klinik Beau-Site',
      grepl('Anna', Hospital) ~ 'Hirslanden Klinik St.Anna',
      grepl('Source', Hospital) ~ 'Clinique de La Source',
      grepl('SZO', Hospital) ~ 'Spitalzentrum Oberwallis (SZO)',
      grepl('HFR', Hospital) ~ 'HFR - Hôpital fribourgeois',
      grepl('Frauen', Hospital) ~ 'Kantonsspital Frauenfeld',
      TRUE ~ Hospital
    )) %>%
    select(Hospital=kz, Year, Score) %>% # build a simple table
    pivot_wider(names_from = Year, values_from = Score) %>%
    arrange_at(2:3, desc) %>%
    write_csv(swissdata)
  
  stopifnot(file.exists(swissdata))
  
  
  message("... build completed ...")
  
}


