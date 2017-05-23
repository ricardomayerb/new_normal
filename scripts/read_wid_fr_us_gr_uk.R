library(readr)
wid_data_top_1_ae <- read_delim("./raw_data/WID_Data_22052017-145730.csv",
";", escape_double = FALSE, trim_ws = TRUE,
skip = 1)
names(wid_data_top_1_ae) <- c("percentil", "year", "uk", "us", "de", "fr", "jp")
wid_data_top_1_ae <- wid_data_top_1_ae[4:nrow( wid_data_top_1_ae), ]

View(wid_data_top_1_ae)
