library(OECD)
data_sets <- get_datasets()
with_GDP <- search_dataset("GDP", data = data_sets)
dset <- "EO"
dstruct <- get_data_structure(dset)
str(dstruct, max.level = 1)

eo_nov_2016 <- get_dataset("EO")

save(eo_nov_2016, file = "./produced_data/oecd_eo_nov_2017")




# EO/AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+EA15+OTO+WLD+NMEC+BRA+CHN+IND+IDN+RUS+ZAF+DAE+OOP.GAP.A/