library(tidyverse)
library(readxl)
library(countrycode)
source("./functions/funcs_for_new_normal.R")

#------- names
load("./produced_data/cepal_18_countries")
load("./produced_data/cepal_33_countries")

weo_country_names_lac_18 <- countrycode(cepal_18_countries[["iso3c"]], "iso3c",
                                        "country.name.en")
weo_country_names_lac_18[2] <- "Bolivia"
weo_country_names_lac_18[18] <- "Venezuela"

weo_country_names_lac_17 <- weo_country_names_lac_18[1:17]

weo_country_names_cardm <- c("Costa Rica", "Dominican Republic", "El Salvador",
                             "Honduras", "Nicaragua", "Mexico", "Guatemala",
                             "Panama")

weo_country_names_card <- c("Costa Rica", "Dominican Republic", "El Salvador",
                            "Honduras", "Nicaragua",  "Guatemala" , "Panama")

weo_country_names_sa <- c("Argentina", "Bolivia", "Brazil", "Chile",
                          "Colombia", "Ecuador", "Paraguay", "Peru",
                          "Uruguay", "Venezuela")

weo_country_names_sa_notven <- c("Argentina", "Bolivia", "Brazil", "Chile",
                                 "Colombia", "Ecuador", "Paraguay", "Peru",
                                 "Uruguay") 

cepal_17_countries <- cepal_18_countries %>% 
  filter(iso3c != "VEN")

cardm_countries <- cepal_18_countries %>% 
  filter(iso3c %in% c("CRI", "HND", "MEX", "DOM", "GTM", "SLV", "PAN", "NIC")  )

card_countries <- cepal_18_countries %>% 
  filter(iso3c %in% c("CRI", "HND", "DOM", "GTM", "SLV", "PAN", "NIC")  )

sa_countries <- cepal_18_countries %>% 
  filter(iso3c %in% c("ARG", "BOL", "BRA", "CHL", "COL", "ECU", "PER",
                      "PRY", "URY", "VEN")  )

sa_countries_notven <- cepal_18_countries %>% 
  filter(iso3c != "VEN"  )

#---- using WEO data
load("./produced_data/WEOApr2017_cepal_and_others")
weo_gdp <- WEOApr2017cepal18_others_long %>% 
  select(iso, country, year, weo_subject_code, value) %>% 
  filter(weo_subject_code %in% c("NGDP_R", "NGDP_RPCH", "NGAP_NPGDP")) 

real_gdp_long <- weo_gdp %>% 
  filter(weo_subject_code %in% c("NGDP_R")) %>% 
  mutate(date =  ymd(paste0(year,  "-12-31"))) 

# foo <- add_ts_filters(real_gdp_long , date_colname = "date", value_colname = "value", country_colname = "iso")

real_gdp_hp <- add_ts_filters(real_gdp_long) %>% arrange(country, date) %>% 
  group_by(country) %>% 
  mutate(trend_growth_pct = simple_net_growth(hp_trend)) %>% 
  ungroup()

trend_growth_list_all <- real_gdp_hp %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016)

trend_growth_list_lac <- real_gdp_hp %>%
  filter(country %in% weo_country_names_lac_18) %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016, this_region_name = "LAC-18")

trend_growth_list_lac_17 <- real_gdp_hp %>%
  filter(country %in% weo_country_names_lac_17) %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016, this_region_name = "LAC-17")

trend_growth_list_cardm <- real_gdp_hp %>%
  filter(country %in% weo_country_names_cardm) %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016, this_region_name = "CARDM")

trend_growth_list_sa <- real_gdp_hp %>%
  filter(country %in% weo_country_names_sa) %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016, this_region_name = "South America")

trend_growth_list_sa_notven <- real_gdp_hp %>%
  filter(country %in% weo_country_names_sa_notven) %>% 
  rename(date_id = date,
         eco_id = country,
         voi = hp_trend) %>% 
  growth_report(end2 = 2016, this_region_name = "South America w.o. Ven")


#---- using oecd data
load("./produced_data/selected_oecd_vars")


#---- using ted data
load("./produced_data/ted_productivity_2016_nov")







