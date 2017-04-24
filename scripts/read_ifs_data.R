library(readr)
library(dplyr)

ifs_coltypes = cols("Country Name" =  "c", "Country Code" =  "c",
                    "Indicator Name" =  "c", "Indicator Code" =  "c",
                    "Attribute" = "c", .default = col_double())

# 
# IFS_yr_qr_m_from_1980 <- read_csv("../IFS/IFS_03-27-2017_timeSeries_from_1980.csv",
#                         col_names = TRUE,
#                         ifs_coltypes)
# 
# IFS_yr_qr_m_from_1980 <- IFS_yr_qr_m_from_1980 %>% 
#   select(-c(`2017M3`:`2017M12`))
# 
# IFS_q_from_1980 <- IFS_yr_qr_m_from_1980 %>% 
#   select(contains("Q"))
# 
# IFS_m_from_1980 <- IFS_yr_qr_m_from_1980 %>% 
#   select(contains("M"))
# 
# IFS_y_from_1980 <- IFS_yr_qr_m_from_1980 %>% 
#   select(one_of(as.character(1980:2016)) )

IFS_yr_qr_m_from_1948 <- read_csv("../IFS/IFS_03-27-2017_timeSeries.csv",
                                  col_names = TRUE,
                                  ifs_coltypes)

IFS_yr_qr_m_from_1948 <- IFS_yr_qr_m_from_1948 %>% 
  select(-c(`2017M3`:`X1196`))

IFS_q_from_1948 <- IFS_yr_qr_m_from_1948 %>% 
  select(1:5, contains("Q"))

IFS_m_from_1948 <- IFS_yr_qr_m_from_1948 %>% 
  select(1:5, contains("M"))

IFS_y_from_1948 <- IFS_yr_qr_m_from_1948 %>% 
  select(1:5, 1:5, one_of(as.character(1948:2016)) )



# save(IFS_y_from_1980, IFS_q_from_1980, IFS_m_from_1980, 
#      file = "../IFS/IFS_yr_qr_m_from_1980.rda")

save(IFS_y_from_1948, IFS_q_from_1948, IFS_m_from_1948, 
     file = "../IFS/IFS_yr_qr_m_from_1948.rda")
