library(readr)
library(dplyr)

ifs_coltypes = cols("Country Name" =  "c", "Country Code" =  "c",
                    "Indicator Name" =  "c", "Indicator Code" =  "c",
                    "Attribute" = "c", .default = col_double())

# BOP_yr_qr <- read_csv("../BOP/BOP_04-04-2017_timeSeries.csv",
#                                   col_names = TRUE,
#                                   ifs_coltypes)


BOP_yr_qr <- read_csv("../BOP/BOP_04-04-2017_timeSeries.csv",
                      col_names = TRUE,
                      ifs_coltypes)

BOP_yr_qr <- BOP_yr_qr %>% 
  select(-`X352`)

BOP_q_from_1948 <- BOP_yr_qr %>% 
  select(1:5, contains("Q"))

BOP_y_from_1948 <- BOP_yr_qr %>% 
  select(1:5, one_of(as.character(1948:2016)) )



save(BOP_y_from_1948, BOP_q_from_1948, 
     file = "../BOP/BOP_yr_qr_from_1948.rda")
