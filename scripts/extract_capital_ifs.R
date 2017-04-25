library(xts)
library(lubridate)
library(tidyr)
library(dplyr)
library(stringr)

load("./produced_data/IFS_cepal18plus_y_long")



unique_indicators <- IFS_y_cepal18plus_long %>% 
  select( `Indicator Code`, `Indicator Name`) %>% 
  distinct()

indicators_with_formation <- unique_indicators %>% 
  filter(str_detect(unique_indicators[["Indicator Name"]],"ormation"))

GDP_nominal_usd_code <- "NGDP_USD"



