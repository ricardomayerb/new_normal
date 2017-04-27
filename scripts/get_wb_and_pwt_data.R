library(wbstats)
library(stringr)
library(dplyr)
library(pwt9)
library(countrycode)
library(readr)

load ("./produced_data/cepal_18_countries")
load ("./produced_data/cepal_33_countries")

my_growth <- function(x) {
  pg <- 100*(x - dplyr::lag(x))/ dplyr::lag(x)
}


new_cache = wbcache()
wbco <-  new_cache$countries
wbind <- new_cache$indicators

ind_with_employed_in_name <- wbind %>% 
  filter(str_detect(wbind$indicator, "employed"))

ind_with_employed_in_desc <- wbind %>% 
  filter(str_detect(wbind$indicatorDesc, "employed"))

ind_with_mployment_in_name <- wbind %>% 
  filter(str_detect(wbind$indicator, "mployment"))

ind_with_employment_in_desc <- wbind %>% 
  filter(str_detect(wbind$indicatorDesc, "employment"))

ind_with_capita_in_name <- wbind %>% 
  filter(str_detect(wbind$indicator, "capita"))

# SL.GDP.PCAP.EM.KD.ZG
# GDP per person employed (annual % growth)
# GDP per person employed is gross domestic product (GDP) divided by total employment in the economy.
# International Labour Organization, Key Indicators of 



not_cepal_countries <- c("USA", "CHN", "RUS", "JPN", "IND", "DEU", "GBR") 

aggregates_codes <-  c("WLD", "LCN", "OED", "EMU", "EUU", "LAC", "LCN", "LCR", "HIC")

this_selection <- c(cepal_33_countries[["iso3c"]], not_cepal_countries, aggregates_codes)

gdp_ppe_ppp = wb(country = this_selection, indicator = "SL.GDP.PCAP.EM.KD")

gdp_per_capita = wb(country = this_selection, indicator = "NY.GDP.PCAP.KD")

employment_to_pop_15plus = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.ZS")

# employment_to_pop_15plus_ne = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.NE.ZS")

total_pop = wb(country = this_selection, indicator = "SP.POP.TOTL")

pop_65plus_pct_of_total = wb(country = this_selection, indicator = "SP.POP.65UP.TO.ZS")

pop_15_64_pct_of_total = wb(country = this_selection, indicator = "SP.POP.1564.TO.ZS")

pop_15up <- left_join(pop_15_64_pct_of_total, 
                      pop_65plus_pct_of_total, by = c("iso2c","date")) %>% 
  mutate(pct_15up = value.x + value.y) %>% 
  select(iso2c, date, pct_15up)





employment_to_pop <- employment_to_pop_15plus %>% 
  rename(emp_to_pop15plus = value) %>% 
  left_join(pop_15up, by = c("iso2c", "date")) %>% 
  mutate(emp_to_pop_ratio = emp_to_pop15plus * pct_15up / 10000) %>% 
  select(iso2c, date, emp_to_pop_ratio)


gdp_per_employed <- gdp_per_capita %>% 
  rename(gdp_per_pop = value,
         indicatorID_gdp_per_pop = indicatorID,
         indicator_gdp_per_pop = indicator) %>% 
  left_join(employment_to_pop, by = c("iso2c", "date")) %>% 
  mutate(gdp_per_emp = gdp_per_pop/emp_to_pop_ratio) %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  mutate(growth_gdp_per_pop = my_growth(gdp_per_pop),
         growth_gdp_per_emp = my_growth(gdp_per_emp)) %>% 
  select(iso2c, country, date, gdp_per_emp, growth_gdp_per_emp,
         gdp_per_pop, growth_gdp_per_pop,
         indicatorID_gdp_per_pop, indicator_gdp_per_pop) %>% 
  mutate(iso3c = countrycode(iso2c, "iso2c", "iso3c")  )

data("pwt9.0")

pwt_gdp_per_employed <- pwt9.0 %>% 
  select(isocode, country, year, pop, emp, rgdpna, rtfpna) %>% 
  filter(isocode %in% this_selection) %>% 
  mutate(emp_to_pop_pwt = emp/pop,
         gdp_to_pop_pwt = rgdpna / pop,
         gdp_to_emp_pwt = rgdpna / emp,
         tfp_pwt = rtfpna) %>% 
  arrange(isocode, year) %>% 
  group_by(isocode) %>% 
  mutate(growth_gdp_to_pop_pwt = my_growth(gdp_to_pop_pwt),
         growth_gdp_to_emp_pwt = my_growth(gdp_to_emp_pwt)) %>% 
  ungroup()




this_selection_18 <- c(cepal_18_countries[["iso3c"]], not_cepal_countries, aggregates_codes)

ted_gracc_txt_url = 'https://www.conference-board.org/retrievefile.cfm?filename=TED_FLATFILE_ADJ_NOV20161.txt&type=subsite'

ted_gracc_data =  read.delim(ted_gracc_txt_url, sep = "\t")


save(ted_gracc_data, pwt_gdp_per_employed , gdp_per_employed,
     file = "./produced_data/gdp_employ_pop_wb_pwt_ted")

# NE.GDI.TOTL.ZS
# Gross capital formation (% of GDP)
# 
# NE.GDI.FTOT.ZS
# Gross fixed capital formation (% of GDP)
# 
# NE.GDI.FTOT.ZS
# Gross fixed capital formation (% of GDP)
# 
# NE.GDI.TOTL.KD.ZG
# Gross capital formation (annual % growth)



# 1	World	WLD
# 2	Low income	LIC
# 3	Middle income	MIC
# 4	  Lower middle income	LMC
# 5	  Upper middle income	UMC
# 6	Low & middle income	LMY
# 7	  East Asia & Pacific (developing only)	EAP
# 8	  Europe & Central Asia (developing only)	ECA
# 9	  Latin America & Caribbean (developing only)	LAC
# 10	  Middle East & North Africa (developing only)	MNA
# 11	  South Asia	SAS
# 12	  Sub-Saharan Africa (developing only)	SSA
# 13	High income	HIC
# 14	  Euro area	EMU
# 15	  High income: OECD	OEC
# 16	  High income: nonOECD	NOC
# 17	Africa	AFR
# 18	Arab World	ARB
# 19	Central Europe and the Baltics	CEB
# 20	East Asia & Pacific (all income levels)	EAS
# 21	Europe & Central Asia (all income levels)	ECS
# 22	European Union	EUU
# 23	Fragile and conflict affected situations	FCS
# 24	Heavily indebted poor countries (HIPC)	HPC
# 25	IBRD only	IBD
# 26	IDA & IBRD total	IBT
# 28	IDA blend	IDB
# 29	IDA only	IDX
# 27	IDA total	IDA
# 30	Latin America & Caribbean (all income levels)	LCN
# 31	Least developed countries: UN classification	LDC
# 32	Middle East & North Africa (all income levels)	MEA
# 33	North America	NAC
# 34	OECD members	OED
# 35	Small states	SST
# 36	  Caribbean small states	CSS
# 37	  Pacific island small states	PSS
# 38	  Other small states	OSS
# 39	Sub-Saharan Africa (all income levels)	SSF






