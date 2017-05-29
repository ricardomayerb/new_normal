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
new_dates <- as.yearqtr(2000 + seq(0,67/4, by = 1/4))
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
  names_portiondata <- new_dates
  
  # names(portiondata) <- names_portiondata
  # names(catdata) <- names_catdata
  
  countrytable <- bind_cols(catdata , portiondata)
  dfs_bop[[i]] <- countrytable 
}

