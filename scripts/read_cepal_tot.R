library(readxl)

term_inter_bs_serv_base_2010 <- read_excel("./raw_data/term_inter_bs_serv.xlsx",
                                           sheet = "base_2010", col_types = c("text",
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
                                      "numeric", "numeric", "skip", "skip",
                              "skip", "skip"))



term_inter_bs_serv_base_2000 <- read_excel("./raw_data/term_inter_bs_serv.xlsx",
sheet = "base_2000", col_types = c("text",
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
"numeric", "numeric", "skip", "skip",
"skip", "skip"))


term_inter_bs_serv_base_2010_tidy <- term_inter_bs_serv_base_2010 %>%
  gather(key = year, value = tot_2000, -Pais) %>% 
  mutate(iso2c = countrycode(Pais, "country.name.es", "iso2c", 
                             custom_dict=cepal_33_countries),
         iso3c = countrycode(Pais, "country.name.es", "iso3c", 
                             custom_dict=cepal_33_countries)
  )



term_inter_bs_serv_base_2000_tidy <- term_inter_bs_serv_base_2000 %>%
  gather(key = year, value = tot_2000, -Pais) %>% 
  mutate(iso2c = countrycode(Pais, "country.name.es", "iso2c", 
                             custom_dict=cepal_33_countries),
         iso3c = countrycode(Pais, "country.name.es", "iso3c", 
                             custom_dict=cepal_33_countries)
  )



save(term_inter_bs_serv_base_2000_tidy, file = "./produced_data/tot_cepal_b2000")



