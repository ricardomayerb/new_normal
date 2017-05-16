library(tidyverse)
library(XLConnect)


wb = loadWorkbook("./raw_data/Credito_interno_abril_2017.xlsx")

sheet_name = "Sheet1"
country_names_mess_ci <- readWorksheet(wb, sheet = 1,
                               startRow = 1, endRow = 1,
                               startCol = 2, endCol = 199, header = FALSE) 

rstart <-  2
rend <-  330
cstarts <- seq(from = 3, by = 6, length.out = 33)
cends <- cstarts + 5

dfs_ci <- list_along(cstarts)

# autofitRow = FALSE is necessary to ensure all blocks have the same number of rows
# irrespective of the date of hte last observation recorded. Equal number of rows is 
# necessary for bind_rows() later
for (i in seq_along(cstarts) ) {
  
  dfs_ci[[i]] <- readWorksheet(wb, sheet = 1,
                                 startRow = rstart, endRow = rend,
                                 startCol = cstarts[[i]], endCol = cends[[i]],
                                 autofitRow = FALSE) 
}


save(dfs_ci, country_names_mess_ci, 
     file="./produced_data/datos_credito_interno_alejandra_messy")

# 
# 
# 
# 
# 
# sheet_name = "Préstamos bancarios"
# country_names_mess_pb <- readWorksheet(wb, sheet = sheet_name,
#                                     startRow = 4, endRow = 4,
#                                     startCol = 2, endCol = 240, header = FALSE) 
# 
# rstart <-  5
# rend <-  349
# cstarts <- seq(from = 2, by = 7, length.out = 33)
# cends <- cstarts + 6
# 
# dfs_pb <- list_along(cstarts)
# 
# for (i in seq_along(cstarts) ) {
#   dfs_pb[[i]] <- readWorksheet(wb, sheet = sheet_name,
#                                startRow = rstart, endRow = rend,
#                                startCol = cstarts[[i]], endCol = cends[[i]],
#                                autofitRow = FALSE) 
# }
# 
# 
# save(tpm, 
#      meta_inf, meta_inf_liminf, meta_inf_limsup,
#      cartera_vencida, 
#      dfs_pb, country_names_mess_pb, 
#      dfs_ci, country_names_mess_ci, 
#      file="./produced_data/datos_mon_finan_alej_messy")
# 
# 
# 
# 
# 
# 
