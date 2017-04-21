library(readr)

char_pos = rep("c",5)
num_pos = rep("d", 1991)

ifs_coltypes = c(char_pos, num_pos)

IFS_yr_qr_m <- read_csv("V:/USR/RMAYER/cw/IFS/IFS_03-27-2017 20-11-19-75_timeSeries.csv",
col_types = ifs_coltypes)

# View(IFS_yr_qr_m)

save(IFS_03_27_2017_20_11_19_75_timeSeries, file = "V:/USR/RMAYER/cw/IFS/IFS_yr_qr_m.rda")
