library(imfr)
library(IMFData)
library(rsdmx)

providers <- getSDMXServiceProviders()
providers_df <- as.data.frame(providers)

myUrl <- "http://data.fao.org/sdmx/repository/data/CROP_PRODUCTION/.156.5312../FAO?startPeriod=2008&endPeriod=2008"
dataset <- readSDMX(myUrl)
stats <- as.data.frame(dataset) 

dbases <-  imf_ids(return_raw = FALSE , times=50)
dbases

availableDB <- DataflowMethod()
sdmx <- readSDMX(providerId = "OECD", resource = "data", flowRef = "MIG",
                 key = list("TOT", NULL, NULL), start = 2010, end = 2011)
df <- as.data.frame(sdmx)
head(df)

sdmx <- readSDMX(providerId = "OECD", resource = "data", flowRef = "MIG",
                 key = list("TOT", NULL, NULL), start = 2010, end = 2011,
                 dsd = TRUE)

df <- as.data.frame(sdmx, labels = TRUE)
head(df)
