library(tidyverse)
library(stringr)
library(countrycode)
library(lubridate)
library(stringi)
library(purrrlyr)

load("./produced_data/datos_credito_interno_alejandra_messy")
load("./produced_data/cepal_33_countries")
load("./produced_data/cepal_18_countries")


## tidyng credito interno

country_names_credito_interno <- country_names_mess_ci %>% 
  select_if(! is.na(country_names_mess_ci)) %>% 
  str_split( "\\(") %>% 
  map_chr( .f = c(1,1)) %>% 
  str_trim()

# insert country names founds in credito interno sheet as a column of each data block
# in the same order as they appeared on top of each block

dates_credito_interno <- seq.Date(from = as.Date("1989-12-01"), to = as.Date("2017-03-01"), by = 'month')

dfs_ci_to_modify = dfs_ci
lower_case_names = str_to_lower(names(dfs_ci_to_modify[[1]]))

for(i in 1:length(dfs_ci)){
  
  names(dfs_ci_to_modify[[i]]) <-  lower_case_names
  
  # print( c(country_names_credito_interno[[i]], names(dfs_ci_to_modify[[i]])))
  
  dfs_ci_to_modify[[i]] <- dmap(dfs_ci_to_modify[[i]], as.numeric)
  
  dfs_ci_to_modify[[i]]$nombre_pais <- country_names_credito_interno[[i]]  
  
  dfs_ci_to_modify[[i]]$date <- dates_credito_interno
}

credito_interno = bind_rows(dfs_ci_to_modify)

credito_interno_tidy <- credito_interno %>% 
   mutate( nombre_pais = recode(nombre_pais, 
                             Bolivia = "Bolivia (Estado Plurinacional de)",
                             Costa.Rica = "Costa Rica",
                             "Rep. Dominicana" = "República Dominicana",
                             "Santa Lucia" = "Santa Lucía",
                             "San Kitts y Nevis" = "Saint Kitts y Nevis",
                             Surinam = "Suriname",
                             "República Bolivariana de Venezuela" = "Venezuela (República Bolivariana de)"),
           year = year(date),
           month = month(date)
           )

names(credito_interno_tidy) <- stringi::stri_trans_general(
  names(credito_interno_tidy), "Latin-ASCII") 


credito_interno_33_tidy <- credito_interno_tidy %>% 
  mutate(iso2c = countrycode(nombre_pais, "country.name.es", "iso2c", 
                             custom_dict=cepal_33_countries),
         iso3c = countrycode(nombre_pais, "country.name.es", "iso3c", 
                             custom_dict=cepal_33_countries))
         




credito_interno_18_tidy = credito_interno_33_tidy %>% 
  filter(nombre_pais %in% cepal_18_countries[["country.name.es"]])




save(credito_interno_33_tidy,
     credito_interno_18_tidy,
     file = "./produced_data/credito_interno_dde_tidy")

