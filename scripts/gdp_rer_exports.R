library(dplyr) # use dplyr::first and dplyr::last
library(ggplot2)
library(tidyr)
library(lubridate)
library(countrycode)
library(AER)
library(ivpack)
library(stringr)

load("./produced_data/WEOApr2017_cepal_and_others")

load("./produced_data/cepal_18_countries")
# load("../produced_data/cepal_33_countries")

rm(WEOApr2017cepal33_others_long, WEOApr2017cepal33_others_wide, 
   WEOApr2017_long, WEOApr2017_wide)

# what variables are available (not the same for countries and groups of countries!) ad what are their codes
subject_dict_co <- WEOApr2017cepal18_others_long %>% 
  filter(iso == "CHL" & year == 2000) %>% 
  select(-c(value, iso, country, country_series_specific_notes,
            weo_country_code, estimates_start_after, scale, year))

subject_dict_wo <- WEOApr2017cepal18_others_long %>% 
  filter(country == "World" & year == 2000) %>% 
  select(-c(value, iso,  country_series_specific_notes,
            weo_country_code, estimates_start_after, scale, year) ) 

weo_country_names_lac_18 <- countrycode(cepal_18_countries[["iso3c"]], "iso3c", "country.name.en")
weo_country_names_lac_18[2] <- "Bolivia"
weo_country_names_lac_18[18] <- "Venezuela"


gdp_and_expo_wide <- WEOApr2017cepal18_others_wide %>% 
  filter(iso %in% cepal_18_countries[["iso3c"]]) %>% 
  select(-c(weo_country_code, subject_notes, units, scale,
            country_series_specific_notes, estimates_start_after)) %>% 
  filter(weo_subject_code %in% c("TX_RPCH", "NGDP_RPCH")) %>% 
  select(-c(`2017`:`2022`)) %>% 
  arrange(country)

gdp_and_expo_long <- WEOApr2017cepal18_others_long %>% 
  filter(iso %in% cepal_18_countries[["iso3c"]]) %>% 
  select(-c(weo_country_code, subject_notes, units, scale,
            country_series_specific_notes, estimates_start_after)) %>% 
  filter(weo_subject_code %in% c("TX_RPCH", "NGDP_RPCH")) %>% 
  filter(year <= 2016) %>% 
  arrange(country, year)

data_from_bart <- read_excel("./raw_data/Data for Regression GDP levels.xlsx",
col_types = c("text", "numeric", "numeric",
"numeric", "numeric", "numeric",
"skip", "skip", "skip", "skip",
"skip", "skip", "skip"))

names(data_from_bart) <- c("country", "id", "year", "nominal_gdp",
                           "nominal_x_s", "reer_2005")

reer_1990_2015 <- data_from_bart %>% 
  select(-c(nominal_gdp, nominal_x_s, id))






