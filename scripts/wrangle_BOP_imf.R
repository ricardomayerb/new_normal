library(tidyr)
library(dplyr)
library(xts)
library(lubridate)

load("../BOP/BOP_yr_qr_from_1948.rda")


load("./produced_data/cepal_33_countries")
load("./produced_data/cepal_18_countries")

ifs_country_names_lac_18 <- cepal_18_countries[["country.name.en"]]
ifs_country_names_lac_18[2] <- "Bolivia"
ifs_country_names_lac_18[18] <- "Venezuela, Republica Bolivariana de"

# advanced economies, usa, UK, China,  europe, euro area, russian federation, japan, germany, india
other_economies_imf_code = c(101, 111, 112, 924, 170, 163, 922, 158, 134, 534)

# 
# BOP_y_from_1948_cepal18_others <- BOP_y_from_1948 %>% 
#   filter(`Country Name` %in% ifs_country_names_lac_18 | 
#            `Country Code` %in% other_economies_imf_code)
# 
# BOP_q_from_1948_cepal18_others <- BOP_q_from_1948 %>% 
#   filter(`Country Name` %in% ifs_country_names_lac_18 | 
#            `Country Code` %in% other_economies_imf_code)
# 
# 
# 


BOP_y_cepal18plus_long <- BOP_y_from_1948 %>% 
  filter(`Country Name` %in% ifs_country_names_lac_18 | 
           `Country Code` %in% other_economies_imf_code) %>% 
  gather(key=year, value=value, `1948`:`2016`) %>% 
  filter(Attribute == "Value") %>% 
  distinct(`Country Name`, `Country Code`, `Indicator Name`, `Indicator Code`,
           `Attribute`, `year`, .keep_all = TRUE  ) %>% 
  mutate(date = paste0(year, "-12-31"),
         date = ymd(date))


BOP_q_cepal18plus_long <-  BOP_q_from_1948 %>% 
  filter(`Country Name` %in% ifs_country_names_lac_18 | 
           `Country Code` %in% other_economies_imf_code) %>% 
  gather(key=yearq, value=value, `1948Q1`:`2016Q4`) %>% 
  select(-`2017Q1`) %>% 
  filter(Attribute == "Value") %>% 
  distinct(`Country Name`, `Country Code`, `Indicator Name`, `Indicator Code`,
           `Attribute`, `yearq`, .keep_all = TRUE  ) %>% 
  mutate(yearq = as.yearqtr(yearq)) %>% 
  mutate(date = date(yearq))


BOP_y_chile_long <- BOP_y_cepal18plus_long %>% 
  filter(`Country Name` == "Chile") 

BOP_y_chile_2013 <- BOP_y_chile_long %>% 
  filter(year == "2013") 

BOP_q_chile_long <- BOP_q_cepal18plus_long %>% 
  filter(`Country Name` == "Chile") 




save(BOP_y_cepal18plus_long, file = "./produced_data/BOP_cepal18plus_y_long")

save(BOP_q_cepal18plus_long, file = "./produced_data/BOP_cepal18plus_q_long")


 