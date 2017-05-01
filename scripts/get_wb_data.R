library(wbstats)
library(stringr)
library(dplyr)

load ("./produced_data/cepal_18_countries")
load ("./produced_data/cepal_33_countries")

my_growth <- function(x) {
  pg <- 100*(x - dplyr::lag(x)) / dplyr::lag(x)
}

my_geoavg_growth <- function(x) {
  en <- length(x)
  rat <- dplyr::last(x)/dplyr::first(x)
  gross_gavg_rate <- rat^(1/en)
  gavg_rate <- 100 * (gross_gavg_rate-1)
}




# new_cache = wbcache()
# 
# wbco <-  new_cache$countries
# 
# wbind <- new_cache$indicators


not_cepal_countries <- c("USA", "CHN", "RUS", "JPN", "IND", "DEU", "GBR") 
aggregates_codes <-  c("WLD", "LCN", "OED", "EMU", "EUU", "LAC", "LCN", "LCR", "HIC")
this_selection <- c(cepal_33_countries[["iso3c"]], not_cepal_countries, aggregates_codes)


inds_with_formation <- wbsearch("capital formation")

gcf_gr <-   wb(country = this_selection, indicator = "NE.GDI.TOTL.KD.ZG")
gfcf_gr <-  wb(country = this_selection, indicator = "NE.GDI.FTOT.KD.ZG")

gfcf_to_gdp <-  wb(country = this_selection, indicator = "NE.GDI.FTOT.ZS")
gcf_to_gdp <-  wb(country = this_selection, indicator = "NE.GDI.TOTL.ZS")

gfcf_to_usd2010 <-  wb(country = this_selection, indicator = "NE.GDI.FTOT.KD")
gcf_to_usd2010 <-  wb(country = this_selection, indicator = "NE.GDI.TOTL.KD")


gfcf_to_coLCU <-  wb(country = this_selection, indicator = "NE.GDI.FTOT.KN")
gcf_to_coLCU <-  wb(country = this_selection, indicator = "NE.GDI.TOTL.KN")

gfcf_to_coLCU <- gfcf_to_coLCU %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  mutate(gfcf_gr = my_growth(value)) %>% 
  ungroup()
  
gcf_to_coLCU <- gcf_to_coLCU %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  mutate(gcf_gr = my_growth(value)) %>% 
  ungroup()



gfcf_to_coLCU_03_08 <- gfcf_to_coLCU %>% 
  filter(date >= 2003 & date <= 2008) %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  summarise(gfcf_gagr_03_08 = my_geoavg_growth(value),
            gfcf_avgr_03_08 = mean(gfcf_gr, na.rm = TRUE)) %>% 
  ungroup()


gfcf_to_coLCU_10_15 <- gfcf_to_coLCU %>% 
  filter(date >= 2010 & date <= 2015) %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  summarise(gfcf_gagr_10_15 = my_geoavg_growth(value),
            gfcf_avgr_10_15 = mean(gfcf_gr, na.rm = TRUE)) %>% 
  ungroup()


gfcf_gr_03_08_10_15 <- left_join(gfcf_to_coLCU_03_08, gfcf_to_coLCU_10_15,
                                 by = c("iso2c")) %>% 
  mutate(cambio_gm = gfcf_gagr_10_15 - gfcf_gagr_03_08,
         cambio_am = gfcf_avgr_10_15 - gfcf_avgr_03_08)



gcf_to_coLCU_03_08 <- gcf_to_coLCU %>% 
  filter(date >= 2003 & date <= 2008) %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  summarise(gcf_gagr_03_08 = my_geoavg_growth(value),
            gcf_avgr_03_08 = mean(gcf_gr, na.rm = TRUE)) %>% 
  ungroup()


gcf_to_coLCU_10_15 <- gfcf_to_coLCU %>% 
  filter(date >= 2010 & date <= 2015) %>% 
  arrange(iso2c, date) %>% 
  group_by(iso2c) %>% 
  summarise(gcf_gagr_10_15 = my_geoavg_growth(value),
            gcf_avgr_10_15 = mean(gcf_gr, na.rm = TRUE)) %>% 
  ungroup()


gcf_gr_03_08_10_15 <- left_join(gcf_to_coLCU_03_08, gcf_to_coLCU_10_15,
                                 by = c("iso2c")) %>% 
  mutate(cambio_gm = gcf_gagr_10_15 - gcf_gagr_03_08,
         cambio_am = gcf_avgr_10_15 - gcf_avgr_03_08)


save(gfcf_gr_03_08_10_15, gfcf_to_coLCU, gfcf_to_gdp,
     file = "./produced_data/gfcf_wb_data")

save(gcf_gr_03_08_10_15, gcf_to_coLCU, gcf_to_gdp,
     file = "./produced_data/gcf_wb_data")

# 
# gdp_ppe_ppp = wb(country = this_selection, indicator = "SL.GDP.PCAP.EM.KD")
# 
# gdp_per_capita = wb(country = this_selection, indicator = "NY.GDP.PCAP.KD")
# 
# employment_to_pop_15plus = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.ZS")
# 
# employment_to_pop_15plus_ne = wb(country = this_selection, indicator = "SL.EMP.TOTL.SP.NE.ZS")
# 
# total_pop = wb(country = this_selection, indicator = "SP.POP.TOTL")
# 
# pop_65plus_pct_of_total = wb(country = this_selection, indicator = "SP.POP.65UP.TO.ZS")
# 
# pop_15_64_pct_of_total = wb(country = this_selection, indicator = "SP.POP.1564.TO.ZS")
# 
# pop_15up <- left_join(pop_15_64_pct_of_total, 
#                       pop_65plus_pct_of_total, by = c("iso2c","date")) %>% 
#   mutate(pct_15up = value.x + value.y)

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






