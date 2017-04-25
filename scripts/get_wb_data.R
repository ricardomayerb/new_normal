library(wbstats)
library(stringr)
library(dplyr)

load ("./produced_data/cepal_18_countries")
load ("./produced_data/cepal_33_countries")

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


SL.EMP.TOTL.SP.NE.ZS


not_cepal_countries <- c("USA", "CHN", "RUS", "JPN", "IND", "DEU", "GBR") 

aggregates_codes <-  c("WLD", "LCN", "OED", "EMU", "EUU", "LAC", "LCN", "LCR", "HIC")

this_selection <- c(cepal_33_countries[["iso3c"]], not_cepal_countries, aggregates_codes)

gdp_ppe_ppp = wb(country = this_selection, indicator = "SL.GDP.PCAP.EM.KD")

gdp_per_capita = wb(country = this_selection, indicator = "NY.GDP.PCAP.KD")

employment_to_pop_15plus = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.ZS")

employment_to_pop_15plus_ne = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.NE.ZS")

total_pop = wb(country = this_selection, indicator = "SP.POP.TOTL")

pop_65plus_pct_of_total = wb(country = this_selection, indicator = "SP.POP.65UP.TO.ZS")

pop_15_64_pct_of_total = wb(country = this_selection, indicator = "SP.POP.1564.TO.ZS")

pop_15up <- left_join(pop_15_64_pct_of_total, 
                      pop_65plus_pct_of_total, by = c("iso2c","date")) %>% 
  mutate(pct_15up = value.x + value.y)

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






