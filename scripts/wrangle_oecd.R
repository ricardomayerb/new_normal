library(dplyr)

load("./produced_data/oecd_eo_nov_2017")

# CBGDPR: Current account balance, as a percentage of GDP
# Export volumes of goods and services XGSVD
# 48. Import volumes of goods and services MGSVD

trade_vars = c("TGSVD", "TGSVD_ANNPCT", "CTGSVD", "XGSVD", "MGSVD")
capital_formation_vars <- c("ITV_ANNPCT", "ITV", "IBV")
gdp_vars <- c("GDPV", "GDPV_ANNPCT ", "GDPVTR", "GAP", "GDP")

productivity_eo_vars <- c("PDTY", "TRPDTY")
productivity_prod_gr_vars <- c("T_MFP", "T_GDPHRS_V", "T_GDPEMP_V",
                               "T_GDPPOP_V")
productivity_prod_lvl_vars <- c("T_MFP", "T_GDPHRS_V", "T_GDPEMP_V",
                               "T_GDPPOP_V")

# T_GDPEMP_V GDP per person employed, constant prices
# T_GDPHRS_V GDP per hour worked, constant prices
# T_MFP Multifactor productivity
# T_GDPPOP_V GDP per capita, constant prices


# PDTY Labour productivity of the total economy 
# TRPDTY Trend labour productivity of the total economy 


# 43. GDP Gross domestic product, value, market prices
# 44. GDPD Gross domestic product, value, at 2010 PPP, USD
# 45. GDP_USD Gross domestic product, value, 2010 exchange rates, USD
# 46. GDPML Gross domestic product, mainland, value
# 47. GDPMLV Gross domestic product, mainland, volume
# 48. GDPOFS Gross domestic product, value, market prices, offshore
# 49. GDPOFSV Gross domestic product, volume, market prices, offshore 
# 50. GDPTR Potential output of total economy, value
# 51. GDPV Gross domestic product, volume, market prices
# 52. GDPVCSA GDP value country specific (annual non-adjusted GDP or output approach GDP), volume
# 53. GDPVD Gross domestic product, volume, at 2010 PPP, USD
# 54. GDPV_USD Gross domestic product, volume, 2010 exchange rates, USD
# 55. GDPVTR Potential output of total economy, volume
# 56. GDPV_ANNPCT Gross domestic product, volume, growth, annualised rate 


gap_data <- eo_nov_2016 %>% 
  filter(VARIABLE == "GAP") %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))

potentialgdp_data <- eo_nov_2016 %>% 
  filter(VARIABLE == "GDPVTR") %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))

capfor_data  <- eo_nov_2016 %>% 
  filter(VARIABLE %in%  capital_formation_vars) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))

gfcf_oecd_data <- eo_nov_2016 %>% 
  filter(VARIABLE %in% c("ITV") ) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))
# 
# CTGSVD. Contribution to world trade volume, Goods and services, USD, 2010 prices
# Goods and services trade volume, USD, 2010 prices (TGSVD)
# TGSVD_ANNPCT

trade_data <- eo_nov_2016 %>% 
  filter(VARIABLE %in%  trade_vars) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))
# .ITV_ANNPCT+ITV+IBV.A

# ITV. Gross fixed capital formation, total, volume
# Gross fixed capital formation growth (volume)
# IBV: Private non-residential fixed capital formation, volume,

selected_eo_vars <- c(gdp_vars, 
                   capital_formation_vars,
                   trade_vars, "PDTY")

selection_oecd_eo_nov_2016 <- eo_nov_2016 %>% 
  filter(VARIABLE %in%  selected_eo_vars) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD))

selection_oecd_prod_gr <- productivity_gr_dataset %>%
  filter(SUBJECT %in%  productivity_prod_gr_vars) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD, OBS_STATUS))
  

selection_oecd_prod_lvl <- productivity_lvl_dataset %>%
  filter(SUBJECT %in%  productivity_prod_lvl_vars) %>% 
  select(-c(TIME_FORMAT, POWERCODE, REFERENCEPERIOD, OBS_STATUS))

save(selection_oecd_eo_nov_2016, selection_oecd_prod_gr,
     selection_oecd_prod_lvl, file = "./produced_data/selected_oecd_vars")
