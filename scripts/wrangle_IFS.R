library(tidyr)
library(dplyr)
library(xts)
library(lubridate)

load("../IFS/IFS_yr_qr_m_from_1948.rda")


load("./produced_data/cepal_33_countries")
load("./produced_data/cepal_18_countries")

ifs_country_names_lac_18 <- cepal_18_countries[["country.name.en"]]
ifs_country_names_lac_18[2] <- "Bolivia"
ifs_country_names_lac_18[18] <- "Venezuela, Republica Bolivariana de"

# advanced economies, usa, UK, China,  europe, euro area, russian federation, japan, germany, india
other_economies_imf_code = c(101, 111, 112, 924, 170, 163, 922, 158, 134, 534)





IFS_y_cepal18plus_long <- IFS_y_from_1948 %>% 
  filter(`Country Name` %in% ifs_country_names_lac_18 | 
           `Country Code` %in% other_economies_imf_code) %>% 
  gather(key=year, value=value, `1948`:`2016`) %>% 
  filter(Attribute == "Value") %>% 
  distinct(`Country Name`, `Country Code`, `Indicator Name`, `Indicator Code`,
           `Attribute`, `year`, .keep_all = TRUE  ) %>% 
  mutate(date = paste0(year, "-12-31"),
         date = ymd(date))


IFS_q_cepal18plus_long <- IFS_q_from_1948 %>% 
  filter(`Country Name` %in% ifs_country_names_lac_18 | 
           `Country Code` %in% other_economies_imf_code) %>% 
  gather(key=yearq, value=value, `1948Q1`:`2016Q4`) %>% 
  select(-`2017Q1`) %>% 
  filter(Attribute == "Value") %>% 
  distinct(`Country Name`, `Country Code`, `Indicator Name`, `Indicator Code`,
           `Attribute`, `yearq`, .keep_all = TRUE  ) %>% 
  mutate(yearq = as.yearqtr(yearq)) %>% 
  mutate(date = date(yearq))

IFS_m_cepal18plus_long <- IFS_m_from_1948 %>% 
  filter(`Country Name` %in% ifs_country_names_lac_18 | 
           `Country Code` %in% other_economies_imf_code) %>% 
  gather(key=yearm, value=value, `1948M1`:`2016M12`) %>% 
  select(-c(`2017M1`, `2017M2`)) %>% 
  filter(Attribute == "Value") %>% 
  distinct(`Country Name`, `Country Code`, `Indicator Name`, `Indicator Code`,
           `Attribute`, `yearm`, .keep_all = TRUE  )  %>% 
  mutate(yearm = as.yearmon(yearm)) %>% 
  mutate(date = date(yearm))

IFS_y_chile_long <- IFS_y_cepal18plus_long %>% 
  filter(`Country Name` == "Chile") 

IFS_q_chile_long <- IFS_q_cepal18plus_long %>% 
  filter(`Country Name` == "Chile") 

IFS_m_chile_long <- IFS_m_cepal18plus_long %>% 
  filter(`Country Name` == "Chile") 



save(IFS_y_cepal18plus_long, file = "./produced_data/IFS_cepal18plus_y_long")

save(IFS_q_cepal18plus_long, file = "./produced_data/IFS_cepal18plus_q_long")

save(IFS_m_cepal18plus_long, file = "./produced_data/IFS_cepal18plus_m_long")
 