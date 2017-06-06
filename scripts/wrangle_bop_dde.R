library(readxl)
library(xts)
library(stringi)
library(stringr)
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)

#----
fin_flows_lac_18 <- read_excel("./raw_data/Bal Pag_TRIMESTRAL_CECILIA_rm.xlsx",
sheet = "inflows_lac_18", col_types = c("text",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric"))

new_dates <- as.yearqtr(2000 + seq(0,67/4, by = 1/4))
new_names <- c("item", new_dates)

fin_flows_lac_17 <- read_excel("./raw_data/Bal Pag_TRIMESTRAL_CECILIA_rm.xlsx",
                               sheet = "inflows_lac_17", col_types = c("text",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric", "numeric",
                                                                       "numeric", "numeric"))


items_col <- fin_flows_lac_17$item

std_items_col <- items_col %>% 
  stri_trans_general("Latin-ASCII") %>% 
  str_replace_all(" ", "_") %>% 
  str_replace_all(":", "") %>% 
  str_to_lower()

fin_flows_lac_17$item <- std_items_col
fin_flows_lac_18$item <- std_items_col

foo_17 <- as.data.frame(fin_flows_lac_17[, -1] %>% t()) 
names(foo_17) <- std_items_col
row.names(foo_17) <- NULL
fin_flows_long_lac_17 <- foo_17 %>% mutate(date = new_dates) %>% 
  select(date, 2:34)

foo_18 <- as.data.frame(fin_flows_lac_18[, -1] %>% t()) 
names(foo_18) <- std_items_col
row.names(foo_18) <- NULL
fin_flows_long_lac_18 <- foo_18 %>% mutate(date = new_dates) %>% 
  select(date, 2:34) 

fin_flows_long_lac_18_yearly <- fin_flows_long_lac_18 %>% 
  mutate(year = lubridate::year(date)) %>% 
  group_by(year) %>% select(-date) %>% 
  summarise_all(sum)

fin_flows_long_lac_17_yearly <- fin_flows_long_lac_17 %>% 
  mutate(year = lubridate::year(date)) %>% 
  group_by(year) %>% select(-date) %>% 
  summarise_all(sum)

fin_flows_17_xts <- fin_flows_long_lac_17 %>% 
  select(-date) %>% 
  xts(order.by = fin_flows_long_lac_17$date)

# fin_flows_17_xts_yearly <- apply.yearly(fin_flows_17_xts


fin_flows_18_xts <- fin_flows_long_lac_18 %>% 
  select(-date) %>% 
  xts(order.by = fin_flows_long_lac_18$date)

# foo <- fin_flows_17_xts[, c("balance_en_cuenta_financiera" , "non_residents_flows")]
# foo <- fin_flows_17_xts[, c(1,3)]


save(fin_flows_18_xts, fin_flows_long_lac_18_yearly, fin_flows_long_lac_18,
     fin_flows_17_xts, fin_flows_long_lac_17_yearly, fin_flows_long_lac_17,
     file = "./produced_data/fin_flows_lac")

#---- 
# by countries
new_dates_2000 <- as.yearqtr(2000 + seq(0,67/4, by = 1/4))
new_dates_1993 <- as.yearqtr(1993 + seq(0,95/4, by = 1/4))
wbpath  = "./raw_data/Bal Pag_TRIMESTRAL_CECILIA_rm.xlsx"
rangedata <- "BI8:EZ62"

firstcolsrange <- "A8:D62"

#same order and names in cecilias workbook
iso_names <- c("ARG","BOL","BRA","CHL","CRI","COL","ECU","SLV","GTM",
               "HND","MEX","NIC","PAN","PRY","PER","DOM","URY","VEN")

rstart <-  8 
rend <-  62
cstart <-  1
cend <- 156

dfs_bop <- list_along(iso_names)
dfs_bop_long <- list_along(iso_names)
dfs_bop_tidy <- list_along(iso_names)

all_countries_tidy <- data_frame()

for (i in seq_along(dfs_bop) ) {
  
  sheet_name <- iso_names[[i]]
  
  catdata <- read_xlsx(path = wbpath, sheet = sheet_name,
                       range = firstcolsrange,
                       col_names = FALSE) 
  
  catdata$pais <- iso_names[[i]]
  
  portiondata <- read_xlsx(path = wbpath, sheet = sheet_name,
                           range = rangedata,
                           col_names = FALSE) 
  
  names_catdata <- c("rubroold", "grupo", "rubro", "manual", "pais")
  names_portiondata <- new_dates_1993
  
  countrytable <- bind_cols(catdata , portiondata)
  names(countrytable) <- c(c(names_catdata), c(names_portiondata))
  
  countrytable_long <- countrytable %>% 
    gather(key = yearq, value = value,
           -c(rubroold, grupo, rubro, manual, pais))
  
  countrytable_tidy <- countrytable_long %>% 
    select(-c(rubroold, manual, grupo)) %>% 
    spread(key = rubro, value = value)
 
  dfs_bop[[i]] <- countrytable 
  dfs_bop_long[[i]] <- countrytable_long 
  dfs_bop_tidy[[i]] <- countrytable_tidy
}
names(dfs_bop) <- iso_names
names(dfs_bop_long) <- iso_names
names(dfs_bop_tidy) <- iso_names

bop_lac_all_countries_tidy <- do.call("rbind", dfs_bop_tidy) %>% 
  mutate(year = floor(as.numeric(yearq)))

non_residents_flows_cols <- c(1,2,23,26,27, 58)
residents_flows_cols <- c(1,2 , 22,3,4, 58)

nrf_lac_all_countries <- bop_lac_all_countries_tidy[,non_residents_flows_cols]
rf_lac_all_countries <- bop_lac_all_countries_tidy[,non_residents_flows_cols]

nrf_all <- bop_lac_all_countries_tidy %>% 
  select(non_residents_flows_cols) 

rf_all <- bop_lac_all_countries_tidy %>% 
  select(residents_flows_cols) 

names(nrf_all)[c(3,4,5)] <- c("ied_eed", "p_cartera", "p_otra")

names(rf_all)[c(3,4,5)] <- c("ied_eee", "a_cartera", "a_otra")

nrf_by_country_year <- nrf_all %>% 
  group_by(pais, year) %>% 
  summarise(ied_eed_y = sum(as.numeric(ied_eed), na.rm = TRUE),
            p_cartera_y = sum(as.numeric(p_cartera), na.rm = TRUE),
            p_otra_y = sum(as.numeric(p_otra), na.rm = TRUE),
            total_nrf = ied_eed_y + p_cartera_y + p_otra_y)

rf_by_country_year <- rf_all %>% 
  group_by(pais, year) %>% 
  summarise(ied_eee_y = sum(as.numeric(ied_eee), na.rm = TRUE),
            a_cartera_y = sum(as.numeric(a_cartera), na.rm = TRUE),
            a_otra_y = sum(as.numeric(a_otra), na.rm = TRUE),
            total_rf = ied_eee_y + a_cartera_y + a_otra_y)


nrf_by_country_year_not_ven <- nrf_all %>% 
  filter(pais != "VEN") %>% 
  group_by(pais, year) %>% 
  summarise(ied_eed_y = sum(as.numeric(ied_eed), na.rm = TRUE),
            p_cartera_y = sum(as.numeric(p_cartera), na.rm = TRUE),
            p_otra_y = sum(as.numeric(p_otra), na.rm = TRUE),
            total_nrf = ied_eed_y + p_cartera_y + p_otra_y)


rf_by_country_year_not_ven <- rf_all %>% 
  filter(pais != "VEN") %>% 
  group_by(pais, year) %>% 
  summarise(ied_eee_y = sum(as.numeric(ied_eee), na.rm = TRUE),
            a_cartera_y = sum(as.numeric(a_cartera), na.rm = TRUE),
            a_otra_y = sum(as.numeric(a_otra), na.rm = TRUE),
            total_rf = ied_eee_y + a_cartera_y + a_otra_y)


save(bop_lac_all_countries_tidy, nrf_by_country_year,
     rf_by_country_year, 
     nrf_by_country_year_not_ven, rf_by_country_year_not_ven,
     file = "./produced_data/all_bops_lac")
