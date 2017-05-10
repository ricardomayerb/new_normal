library(tidyverse)
library(stringr)
library(countrycode)

load("./produced_data/bis_gap_tc_dsr")

names(c_gaps1703_qs) <- str_trim(names(c_gaps1703_qs))

c_g_qs_long <- gather(c_gaps1703_qs, key = code, value, -Period) %>% 
  rename(date = Period) %>% 
  mutate(country_name = 
           countrycode(
             str_extract(code, "(?<=:).*?(?=:)" ),
             "iso2c",
             "country.name.en")
         )
c_g_qs_long$country_name[str_detect(c_g_qs_long$code, "Q:XM")] <- "euro_area" 

cr_gap_bis_actualval <- c_g_qs_long %>% 
  filter(str_detect(code, ":A$"))

cr_gap_bis_hpval <- c_g_qs_long %>% 
  filter(str_detect(code, ":B$"))

cr_gap_bis_gapval <- c_g_qs_long %>% 
  filter(str_detect(code, ":C$"))

# Euro area
# Q:XM:N:A:M:770:A
# 
# G20 (aggregate)
# Q:G2:H:A:M:799:A
# 
# Advanced economies (aggregate)
# Q:5R:G:A:N:770:A
# 
# Emerging markets (aggregate)
# Q:4T:G:A:N:799:A
# 
# All reporting countries (aggregate)
# Q:5A:N:A:M:770:A


tc_qs_long <- gather(totcredit_qs, key = code, value, -Period) %>% 
  rename(date = Period) %>% 
  mutate(country_name = 
           countrycode(
             str_extract(code, "(?<=:).*?(?=:)" ),
             "iso2c",
             "country.name.en")
  ) 

tc_qs_long$country_name[str_detect(tc_qs_long$code, "Q:5A")] <- "all_reporting_economies" 
tc_qs_long$country_name[str_detect(tc_qs_long$code, "Q:5R")] <- "advanced_economies" 
tc_qs_long$country_name[str_detect(tc_qs_long$code, "Q:4T")] <- "emerging_markets" 
tc_qs_long$country_name[str_detect(tc_qs_long$code, "Q:XM")] <- "euro_area" 
tc_qs_long$country_name[str_detect(tc_qs_long$code, "Q:G20")] <- "G20"

save(c_gaps1703_content, c_gaps1703_documentation, 
     c_g_qs_long, cr_gap_bis_actualval, cr_gap_bis_hpval,
     cr_gap_bis_gapval, c_g_qs_long, tc_qs_long, file = "./produced_data/bis_tidy")

# foo <- dsr_documentation$Code
# str_extract(foo, "(?<=:).*?(?=:)" )
# str_extract(foo[1], "(?<=:).*?(?=:)" )
# str_extract(dsr_qs_long$code, "(?<=:).*?(?=:)" )
# countrycode(str_extract(dsr_qs_long$code, "(?<=:).*?(?=:)" ), "iso2c", "country.name.en")
