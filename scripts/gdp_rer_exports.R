library(dplyr) # use dplyr::first and dplyr::last
library(ggplot2)
library(tidyr)
library(lubridate)
library(countrycode)
library(AER)
library(ivpack)
library(stringr)
library(RcppRoll)
library(xts)
library(lubridate)
library(roll)

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

# percent change of GDP at constant prices and growth of exports at constant prices
pch_gdp_and_expo_to_panel <- WEOApr2017cepal18_others_long %>% 
  filter(iso %in% cepal_18_countries[["iso3c"]]) %>% 
  select(-c(weo_country_code, subject_notes, units, scale,
            country_series_specific_notes, estimates_start_after,
            iso, subject_descriptor)) %>% 
  filter(weo_subject_code %in% c("TX_RPCH", "NGDP_RPCH")) %>% 
  filter(year <= 2016) %>% 
  mutate(year = as.numeric(year)) %>% 
  arrange(country, year) %>% 
  spread(key = weo_subject_code, value = value) %>% 
  rename(gdp_pch = NGDP_RPCH, x_pch = TX_RPCH)


data_from_bart <- read_excel("./raw_data/Data for Regression GDP levels.xlsx",
col_types = c("text", "numeric", "numeric",
"numeric", "numeric", "numeric",
"skip", "skip", "skip", "skip",
"skip", "skip", "skip"))

names(data_from_bart) <- c("country", "id", "year", "nominal_gdp",
                           "nominal_x_s", "reer_2005")

reer_1990_2015 <- data_from_bart %>% 
  select(-c(nominal_gdp, nominal_x_s, id))

gdp_x_reer <- reer_1990_2015 %>% 
  left_join(pch_gdp_and_expo_to_panel, by = c("country", "year")) %>% 
  select(country, year, gdp_pch, x_pch, reer_2005)

corr_by_country <- gdp_x_reer %>% 
  group_by(country) %>% 
  summarise(c_gdp_x = cor(gdp_pch, x_pch),
            c_gdp_reer = cor(gdp_pch, reer_2005))


chl_data <- gdp_x_reer %>% filter(country == "Chile") %>% 
  select(-country) %>% 
  mutate(year = ymd(paste0(year, "-12-31")))


chl_data_xts <- as.xts(chl_data[, 3:5], order.by = chl_data$year)
foo <- roll::roll_cor(chl_data_xts, width = 5)
foo_gx <-  foo[2, 1, ]
foo_gr <-  foo[3, 1, ]
foo_rx <-  foo[3, 2, ]

foo_xts <- as.xts(cbind(foo_gr, foo_gx, foo_rx), order.by = index(chl_data_xts))

library(ggfortify)


get_rcor <- function(df) {
  df_xts <- as.xts(df[, 2:4], order.by = df$year)
  foo <- roll::roll_cor(chl_data_xts, width = 5)
  foo_gx <-  foo[2, 1, ]
  foo_gr <-  foo[3, 1, ]
  foo_rx <-  foo[3, 2, ]
  foo_xts <- as.xts(cbind(foo_gr, foo_gx, foo_rx), order.by = index(chl_data_xts))
}

goo_xts <- get_rcor(chl_data)
