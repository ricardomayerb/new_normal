library(OECD)
library(dplyr)

data_sets <- get_datasets()
with_GDP <- search_dataset("GDP", data = data_sets)
with_Glance <- search_dataset("Glance", data = data_sets)
dset <- "EO"
dstruct <- get_data_structure("NAAG")
str(dstruct, max.level = 1)

# National Accounts at a Glance
nacc_at_glance <- get_dataset("NAAG") 


eo_nov_2016 <- get_dataset("EO")

productivity_gr_dataset <- get_dataset("PDB_GR")

productivity_lvl_dataset <- get_dataset("PDB_LV")

save(nacc_at_glance, file = "./produced_data/oecd_naccag")


save(eo_nov_2016, productivity_gr_dataset, productivity_lvl_dataset ,
     file = "./produced_data/oecd_eo_nov_2017")


# EO/AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+EA15+OTO+WLD+NMEC+BRA+CHN+IND+IDN+RUS+ZAF+DAE+OOP.GAP.A/