library(countrycode)
library(dplyr)

ca_sa_region = c("Central America", "South America")
sa_not_cepal = c("FLK", "GUF")
cepal_caribbean = c("ATG","BHS", "BRB", "CUB", "DMA",
                    "DOM", "GRD", "HTI", "JAM", "KNA",
                    "LCA", "VCT", "TTO")

cepal_33_countries <- countrycode_data %>% 
                select(iso2c, iso3c, country.name.en, country.name.es, region) %>% 
                filter(region %in% ca_sa_region | iso3c %in% cepal_caribbean) %>% 
                filter(! iso3c  %in%  sa_not_cepal) 
                

# fix the Trinidad yTobago entry and change it to Trinidad y Tabago
cepal_33_countries$country.name.es[cepal_33_countries$iso3c == "TTO"] <- "Trinidad y Tabago"


carib_minus_dom_plus_jam = c("ATG", "BHS", "BRB", "DMA", "GRD", 
                    "HTI", "KNA", "LCA", "TTO", "VCT")

carib_minus_dom = c("ATG", "BHS", "BRB", "DMA", "GRD", 
                    "HTI", "KNA", "LCA", "TTO", "VCT", "JAM")

other_to_drop = c("GUY", "SUR", "BLZ") 

# # without caribbean (except cuba, dom rep and jamaica) and without belize, suriname and guyana
# cepal_20_countries = cepal_33_countries %>% 
#   filter(!iso3c %in% carib_minus_dom_plus_jam) %>% 
#   filter(!iso3c %in% other_to_drop)

# only DOM and CUB remain from caribbean
cepal_19_countries = cepal_33_countries %>% 
  filter(!iso3c %in% carib_minus_dom) %>% 
  filter(!iso3c %in% other_to_drop)

# only DOM remains from caribbean
cepal_18_countries = cepal_19_countries %>% 
  filter(!iso3c %in% c("CUB"))

save(cepal_33_countries, file = "./produced_data/cepal_33_countries")
save(cepal_19_countries, file = "./produced_data/cepal_19_countries")
save(cepal_18_countries, file = "./produced_data/cepal_18_countries")




