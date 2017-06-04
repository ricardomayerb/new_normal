library(openxlsx)
library(ggplot2)
Sys.setenv("R_ZIPCMD" = "C://Rtools//bin//zip")

load("./specific_rmds/list_of_final_figures")
fig_names <- names(figs_to_export)
data_fig_names <-  paste0("data_", fig_names)

data_from_figs <- lapply(figs_to_export, function(x) ggplot_build(x)$data )
names(data_from_figs) <- data_fig_names

# write.xlsx(data_from_figs, "moo.xlsx")
# 
# wb <- createWorkbook()
# addWorksheet(wb, sheetName = fig_names[[1]])
# print(figs_to_export[[1]])
# insertPlot(wb,  fig_names[[1]])
# addWorksheet(wb, sheetName = data_fig_names[[1]])
# writeData(wb, data_fig_names[[1]], x=data_from_figs[[1]] )
# saveWorkbook(wb, "soo.xlsx", overwrite = TRUE)

figswb <- createWorkbook()
for (i in seq_along(fig_names)) {
  addWorksheet(figswb, sheetName = fig_names[[i]])
  # print(figs_to_export[[i]])
  # insertPlot(figswb,  fig_names[[i]])
  ggsave(paste0(fig_names[[i]],".png"), plot = figs_to_export[[i]])
  insertImage(figswb,  fig_names[[i]],file = paste0(fig_names[[i]],".png"))
  addWorksheet(figswb, sheetName = data_fig_names[[i]])
  writeData(figswb, data_fig_names[[i]], x=data_from_figs[[i]] )
  
}
saveWorkbook(figswb, "doo.xlsx", overwrite = TRUE)



# cf520 <- 119
# cf620 <- 143
# cf940 <- 193
# wifi <- 26
# timer <- 6
# 
# prim1000 <- 109
# prim750 <- 98.3
# prim1500 <- 121
# prim2000 <- 140
# 
# prim_op1 <- 1.19*(prim750 + prim750 + prim2000)
# 
# prim_op2 <- 1.19*(prim1000 + prim1000 + prim750 + prim750)
# 
# prim_op3 <- 1.19*(prim1500 + prim750 + prim750)
