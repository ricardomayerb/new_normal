library(readr)

WEOOct2016all <- read_delim("./raw_data/WEOOct2016all.xls",
"\t", escape_double = FALSE, trim_ws = TRUE)

WEOOct2016alla <- read_delim("./raw_data/WEOOct2016alla.xls",
"\t", escape_double = FALSE, trim_ws = TRUE)


gdp_gap_all_countries <- WEOOct2016all %>% 
  filter(`WEO Subject Code` %in% c("NGAP_NPGDP", "NGDP_R"))


investment <- WEOOct2016all %>% 
  filter(`WEO Subject Code` %in% c("NID_NGDP"))
