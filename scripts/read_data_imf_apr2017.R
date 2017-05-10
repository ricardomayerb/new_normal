library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)

load("./produced_data/cepal_33_countries")
load("./produced_data/cepal_18_countries")

not_cepal_countries <- c("USA", "CHN") 

WEOApr2017all <- read_excel("./raw_data/WEOApr2017all_excel.xlsx",
col_types = c("numeric", "text", "text",
"text", "text", "text", "text", "text",
"text", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric"))




WEOApr2017alla <- read_excel("./raw_data/WEOApr2017alla_excel.xlsx",
col_types = c("numeric", "text", "text",
"text", "text", "text", "text", "text",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric"))



WEOApr2017alla_tm <- WEOApr2017alla
WEOApr2017alla_tm$ISO <- NA
names(WEOApr2017alla_tm)[1] <- "WEO Country Code"
names(WEOApr2017alla_tm)[3] <- "Country"
names(WEOApr2017alla_tm)[8] <- "Country/Series-specific Notes"



WEOApr2017alla_tm <- WEOApr2017alla_tm %>% 
  filter(!is.na(`WEO Country Code`) )

# hack to bump ISO column to the last column and match order of WEOApr2017alla_tm
ciso <- WEOApr2017all$ISO
WEOApr2017all$ISO <- NULL
WEOApr2017all$ISO <- ciso

# if TRUE, we are ready to row bind the two data sets
identical(names(WEOApr2017all), names(WEOApr2017alla_tm))

WEOApr2017_wide <- bind_rows(WEOApr2017all, WEOApr2017alla_tm)

old_names <- names(WEOApr2017_wide)

new_names <- old_names %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_") %>% 
  str_replace_all("-", "_") %>% 
  str_replace_all("/", "_")
  
names(WEOApr2017_wide) <- new_names  

WEOApr2017_long <- WEOApr2017_wide %>% 
  gather(year, value, `1980`:`2022`)

WEOApr2017cepal33_others_wide <- WEOApr2017_wide %>% 
  filter(iso %in% cepal_33_countries[["iso3c"]] | iso %in% not_cepal_countries |
           weo_country_code %in% c(1, 110, 119, 123, 505, 163, 200, 205, 406, 603))

WEOApr2017cepal18_others_wide <-  WEOApr2017_wide %>% 
  filter(iso %in% cepal_18_countries[["iso3c"]] | iso %in% not_cepal_countries |
           weo_country_code %in% c(1, 110, 119, 123, 505, 163, 200, 205, 406, 603))

WEOApr2017cepal33_others_long <- WEOApr2017_long %>% 
  filter(iso %in% cepal_33_countries[["iso3c"]] | iso %in% not_cepal_countries |
           weo_country_code %in% c(1, 110, 119, 123, 505, 163, 200, 205, 406, 603))


WEOApr2017cepal18_others_long <-  WEOApr2017_long %>% 
  filter(iso %in% cepal_18_countries[["iso3c"]] | iso %in% not_cepal_countries |
           weo_country_code %in% c(1, 110, 119, 123, 505,  163, 200, 205, 406, 603))



save(WEOApr2017_long, WEOApr2017_wide,
     WEOApr2017cepal18_others_long, WEOApr2017cepal18_others_wide,
     WEOApr2017cepal33_others_long, WEOApr2017cepal33_others_wide,
     file = "./produced_data/WEOApr2017_cepal_and_others")




