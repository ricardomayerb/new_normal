library(readr)
library(dplyr)

load("./produced_data/cepal_33_countries")
load("./produced_data/cepal_18_countries")

not_cepal_countries <- c("USA", "CHN") 

WEOOct2016all <- read_delim("./raw_data/WEOOct2016all.xls",
"\t", escape_double = FALSE, trim_ws = TRUE, na = "n/a",
col_types = cols("WEO Country Code" = "i",
                 "1980" = "d","1981" = "d","1982" = "d","1983" = "d","1984" = "d",
                 "1985" = "d","1986" = "d","1987" = "d","1988" = "d","1989" = "d",
                 "1990" = "d","1991" = "d","1992" = "d","1993" = "d","1994" = "d",
                 "1995" = "d","1996" = "d","1997" = "d","1998" = "d","1999" = "d",
                 "2000" = "d","2001" = "d","2002" = "d","2003" = "d","2004" = "d",
                 "2005" = "d","2006" = "d","2007" = "d","2008" = "d","2009" = "d",
                 "2010" = "d","2011" = "d","2012" = "d","2013" = "d","2014" = "d",
                 "2015" = "d","2016" = "d","2017" = "d","2018" = "d","2019" = "d",
                 "2020" = "d","2021" = "d"))

WEOOct2016alla <- read_delim("./raw_data/WEOOct2016alla.xls",
"\t", escape_double = FALSE, trim_ws = TRUE, na = "n/a",
col_types = cols("WEO Country Group Code" = "i",
                 "1980" = "d","1981" = "d","1982" = "d","1983" = "d","1984" = "d",
                 "1985" = "d","1986" = "d","1987" = "d","1988" = "d","1989" = "d",
                 "1990" = "d","1991" = "d","1992" = "d","1993" = "d","1994" = "d",
                 "1995" = "d","1996" = "d","1997" = "d","1998" = "d","1999" = "d",
                 "2000" = "d","2001" = "d","2002" = "d","2003" = "d","2004" = "d",
                 "2005" = "d","2006" = "d","2007" = "d","2008" = "d","2009" = "d",
                 "2010" = "d","2011" = "d","2012" = "d","2013" = "d","2014" = "d",
                 "2015" = "d","2016" = "d","2017" = "d","2018" = "d","2019" = "d",
                 "2020" = "d","2021" = "d"))

WEOOct2016alla_tm <- WEOOct2016alla
WEOOct2016alla_tm$ISO <- NA
names(WEOOct2016alla_tm)[1] <- "WEO Country Code"
names(WEOOct2016alla_tm)[3] <- "Country"
names(WEOOct2016alla_tm)[8] <- "Country/Series-specific Notes"

WEOOct2016alla_tm$`Estimates Start After` <- as.integer(WEOOct2016alla_tm$`Estimates Start After`) 

WEOOct2016alla_tm <- WEOOct2016alla_tm %>% 
  filter(!is.na(`WEO Country Code`) )

# hack to bump ISO column to the last column and match order of WEOOct2016alla_tm
ciso <- WEOOct2016all$ISO
WEOOct2016all$ISO <- NULL
WEOOct2016all$ISO <- ciso

# if TRUE, we are ready to row bind the two data sets
identical(names(WEOOct2016all), names(WEOOct2016alla_tm))

WEOOct2016_cou_and_agg <- bind_rows(WEOOct2016all, WEOOct2016alla_tm)



WEOOct2016cepal33_others <- WEOOct2016_cou_and_agg %>% 
  filter(ISO %in% cepal_33_countries[["iso3c"]] | ISO %in% not_cepal_countries |
           `WEO Country Code` %in% c(1, 163, 200, 205))

WEOOct2016cepal18_others <-  WEOOct2016_cou_and_agg %>% 
  filter(ISO %in% cepal_18_countries[["iso3c"]] | ISO %in% not_cepal_countries |
           `WEO Country Code` %in% c(1, 163, 200, 205))



gdp_gap <- WEOOct2016cepal18_others %>% 
  filter(`WEO Subject Code` %in% c("NGAP_NPGDP")  )

gdp <- WEOOct2016cepal18_others %>% 
  filter(`WEO Subject Code` %in% c("NGDP_R")) 


investment <- WEOOct2016cepal18_others %>% 
  filter(`WEO Subject Code` %in% c("NID_NGDP"))


save(WEOOct2016cepal18_others, WEOOct2016cepal33_others, 
     file = "./produced_data/WEO_cepal_and_others")




