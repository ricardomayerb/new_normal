library(dplyr) # use dplyr::first and dplyr::last
library(ggplot2)
library(xts) # use xts::first and xts::last
library(tidyr)
library(lubridate)
library(tibble)
library(tidyquant)
source("./functions/funcs_for_new_normal.R")

load("./produced_data/WEOApr2017_cepal_and_others")

subject_dict_co <- WEOApr2017cepal18_others_long %>% 
  filter(iso == "CHL" & year == 2000) %>% 
  select(-c(value, iso, country, country_series_specific_notes,
            weo_country_code, estimates_start_after, scale, year))

subject_dict_wo <- WEOApr2017cepal18_others_long %>% 
  filter(country == "World" & year == 2000) %>% 
  select(-c(value, iso,  country_series_specific_notes,
            weo_country_code, estimates_start_after, scale, year))

weo_few <- WEOApr2017cepal18_others_long %>% 
  select(iso, country, year, weo_subject_code, value) %>% 
  filter(weo_subject_code %in% c("NGDP_R", "NGDP_RPCH", "NGAP_NPGDP")) 

real_gdp_long <- weo_few %>% 
  filter(weo_subject_code %in% c("NGDP_R")) %>% 
  mutate(date =  ymd(paste0(year,  "-12-31"))) 

# foo <- add_ts_filters(real_gdp_long , date_colname = "date", value_colname = "value", country_colname = "iso")

real_gdp_hp <- add_ts_filters(real_gdp_long) %>% arrange(country, date) %>% 
  group_by(country) %>% 
  mutate(trend_growth_pct = 100*(hp_trend / dplyr::lag(hp_trend)-1)    )

trend_growth_2003_2008 <- real_gdp_hp %>% 
  filter(year>=2003 & year <= 2008) %>% 
  summarise(avg_tg_2003_2008 = mean(trend_growth_pct))

trend_growth_2010_2016 <- real_gdp_hp %>% 
  filter(year>=2010 & year <= 2016) %>% 
  summarise(avg_tg_2010_2016 = mean(trend_growth_pct))

trend_growth_2003_2008_2010_2016 <- left_join(trend_growth_2003_2008,
                                              trend_growth_2010_2016,
                                              by = "country") %>% 
  mutate(dif = avg_tg_2010_2016 - avg_tg_2003_2008 )


  
  
real_gdp_country_wide <- real_gdp_long %>% 
  spread(key = country, value=value)

real_gdp_growth_long <- weo_few %>% 
  filter(weo_subject_code %in% c("NGDP_RPCH"))


weo_long_EU_AE_G7 <- subset(weo_few , 
                country %in% c("Major advanced economies (G7)",
                               "Euro area " , "Advanced economies")) %>% 
  select(-iso) %>% arrange(country, year)

weo_cwide_EU_AE_G7 <- weo_long_EU_AE_G7 %>% spread(weo_subject_code, value) %>% 
  group_by(country) %>% 
  mutate(gross_gap = 1 + NGAP_NPGDP/100,
         gross_rate_gdp = 1 + NGDP_RPCH/100,
         gross_rate_potetial_gdp = gross_rate_gdp*dplyr::lag(gross_gap)/gross_gap,
         growth_potential_pct = 100*(gross_rate_potetial_gdp-1))


EU_AE_G7_tg_2003_2008 <- weo_cwide_EU_AE_G7 %>% 
  filter(year>=2003 & year <= 2008) %>% 
  summarise(avg_tg_2003_2008 = mean(growth_potential_pct))

EU_AE_G7_tg_2010_2016 <- weo_cwide_EU_AE_G7 %>% 
  filter(year>=2010 & year <= 2016) %>% 
  summarise(avg_tg_2010_2016 = mean(growth_potential_pct))

trend_growth_AE_G7_EU_2003_2008_2010_2016 <- left_join(EU_AE_G7_tg_2003_2008,
                                                       EU_AE_G7_tg_2010_2016,
                                              by = "country") %>% 
  mutate(dif = avg_tg_2010_2016-avg_tg_2003_2008)
  
real_gdp_gap_weo_long <-  weo_few %>% 
  filter(weo_subject_code %in% c("NGAP_NPGDP"))

real_gdp_wide <- real_gdp_long %>% 
  spread(key=year, value=value)

real_gdp_growth_wide <- real_gdp_growth_long %>% 
  spread(key=year, value=value)

real_gdp_gap_weo_wide <- real_gdp_gap_weo_long %>% 
  spread(key=year, value=value)

