library(readxl)
library(countrycode)

cepalstat_q5_to_q1 <- read_excel("./raw_data/cepalstat_q5_to_q1.xlsx",
col_types = c("text", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric"))

cepalstat_q5_to_q1_tidy <- cepalstat_q5_to_q1 %>%
  gather(key = year, value = q5_to_q1, -Pais) %>% 
  mutate(iso2c = countrycode(Pais, "country.name.es", "iso2c", 
                             custom_dict=cepal_33_countries),
         iso3c = countrycode(Pais, "country.name.es", "iso3c", 
                             custom_dict=cepal_33_countries)
  )



save(cepalstat_q5_to_q1_tidy, file = "./produced_data/cepalstat_q5_to_q1")

