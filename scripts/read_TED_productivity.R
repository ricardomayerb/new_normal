library(readxl)

ted_nov_2016_countries <- read_excel("./raw_data/TED_1_NOV20161_no_pre_headers.xlsx", 
                                                sheet = "TCB_ADJUSTED", skip = 4)

ted_nov_2016_regions <- read_excel("./raw_data/TED_REGIONS_NOV20161.xlsx",
sheet = "DATA_ADJUSTED", skip = 4)

save(ted_nov_2016_countries, ted_nov_2016_regions,
     file = "./produced_data/ted_productivity_2016_nov")
