library(readr)
library(dplyr)
library(tidyr)

source("./functions/funcs_for_new_normal.R")

load("./produced_data/cepal_18_countries")

quiet_iso <- purrr::quietly(add_iso)

my_growth <- function(x) {
  pg <- 100*(x - dplyr::lag(x))/ dplyr::lag(x)
}

cepalstat_capital_formation <-
  read_delim(
    "./raw_data/formacion_bcf_cepalstat.csv",
    ";",
    escape_double = FALSE,
    trim_ws = TRUE,
    locale = locale("es", encoding = "windows-1252")
  )

new_cols <-  ncol(cepalstat_capital_formation) - 1

cepalstat_capital_formation <-  select(cepalstat_capital_formation, 1:new_cols)

cepalstat_capital_formation <- cepalstat_capital_formation %>% 
  separate(col = `País [Año base]`, into = c("País", "base_year"), sep = " \\[")
  
  
# nombres_mes <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", 
#                  "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")

cs_fbcf <- quiet_iso(df = cepalstat_capital_formation,
                             names_col = "País", dict = cepal_18_countries,
                     rm_nf = TRUE)$result %>% rename(year = `Años`) 




# unique(cs_sr_mn$indicador)
# [1] "Producto interno bruto anual (PIB) por objeto del gasto a precios constantes en moneda nacional"

# > unique(cs_sr_mn$Rubro)
# [1] "Formación bruta de capital fijo: Activos intangibles, terrenos, construcciones, servicios de construcción"
# [2] "Formación bruta de capital fijo (nacional)"                                                               
# [3] "Formación bruta de capital fijo (importado)"                                                              
# [4] "Variación de existencias"                                                                                 
# [5] "Exportaciones de bienes y servicios"                                                                      
# [6] "Importaciones de bienes y servicios"                                                                      
# [7] "Discrepancia estadística"                                                                                 
# [8] "Producto interno bruto (PIB)"                                                                             
# [9] "Gasto de consumo final privado"                                                                           
# [10] "Formación bruta de capital"                                                                               
# [11] "Formación bruta de capital fijo"                                                                          
# [12] "Formación bruta de capital fijo: Productos de la industria manufacturera"                                 
# [13] "Gasto de consumo final"                                                                                   
# [14] "Gasto de consumo final del gobierno general"                                                              
# [15] "Formación bruta de capital fijo del sector público"                                                       
# [16] "Formación bruta de capital fijo del sector privado"                                                       
# [17] "Exportaciones de bienes"                                                                                  
# [18] "Exportaciones de servicios"                                                                               
# [19] "Importaciones de bienes"                                                                                  
# [20] "Importaciones de servicios"                                                                               
# [21] "Gasto de consumo final de los hogares"                                                                    
# [22] "Gasto de consumo final de las instituciones sin fines de lucro que sirven a los hogares"                  
# [23] "Formación bruta de capital fijo: Productos de la agricultura, la silvicultura y la pesca"                 
# [24] "Formación bruta de capital fijo: Servicios prestados a las empresas y servicios de producción"            
# [25] "Compras directas en el mercado interno por no residentes"                                                 
# [26] "Compras directas en el mercado exterior por residentes"                                                   
# [27] "Adquisiciones menos disposiciones de objetos valiosos"                                                    
# > 

cepalstat_sector_real_mn <-
  read_delim(
    "./raw_data/sector_real_moneda_nacional.csv",
    ";",
    escape_double = FALSE,
    trim_ws = TRUE,
    locale = locale("es", encoding = "windows-1252")
  )

new_cols <-  ncol(cepalstat_sector_real_mn) - 1

cepalstat_sector_real_mn <-  select(cepalstat_sector_real_mn, 1:new_cols)

cepalstat_sector_real_mn <- cepalstat_sector_real_mn %>% 
  separate(col = `País [Año base]`, into = c("País", "base_year"), sep = " \\[")


# nombres_mes <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", 
#                  "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")

cs_sr_mn <- quiet_iso(df = cepalstat_sector_real_mn,
                     names_col = "País", dict = cepal_18_countries,
                     rm_nf = TRUE)$result %>% rename(year = `Años`) 

cs_fbcf_pib_indic <-  c("Producto interno bruto (PIB)",
                      "Formación bruta de capital",
                      "Formación bruta de capital fijo",
                      "Formación bruta de capital fijo: Productos de la industria manufacturera",
                      "Formación bruta de capital fijo del sector público",
                      "Formación bruta de capital fijo del sector privado",
                      "Formación bruta de capital fijo: Productos de la agricultura, la silvicultura y la pesca",
                      "Formación bruta de capital fijo: Servicios prestados a las empresas y servicios de producción",
                      "Formación bruta de capital fijo: Activos intangibles, terrenos, construcciones, servicios de construcción",
                      "Formación bruta de capital fijo (nacional)",
                      "Formación bruta de capital fijo (importado)")  
                      

cs_fbcf_pib <- cs_sr_mn %>% 
  filter(Rubro %in% cs_fbcf_pib_indic)

cs_fbcf_ratio_pib <- cs_fbcf_pib %>% 
  select(-indicador ) %>% 
  spread(key = Rubro, value = valor) %>% 
  mutate(fbcf_gdp = `Formación bruta de capital fijo`/`Producto interno bruto (PIB)`,
         fbc_gdp = `Formación bruta de capital`/`Producto interno bruto (PIB)`,
         fbcf_pub_gdp = `Formación bruta de capital fijo del sector público`/`Producto interno bruto (PIB)`,
         fbcf_pri_gdp = `Formación bruta de capital fijo del sector privado`/`Producto interno bruto (PIB)`)

names(cs_fbcf_ratio_pib)[6:16] <- c("fbc", "fbcf", "fbcf_imp",
                                    "fbcf_nac", "fbcf_pri", "pbcf_pub",
                                    "fbcf_aitc", "fbcf_agr", "fbcf_manuf",
                                    "fbcf_servemp", "gdp_lcu_cons")



cs_fbcf_ratio_pib <- cs_fbcf_ratio_pib %>% 
  group_by(iso3c) %>% 
  mutate(fbc_gr = my_growth(fbc),
         fbcf_gr = my_growth(fbcf)) %>% 
  ungroup()


save(cs_fbcf_ratio_pib, file = "./produced_data/cs_fbcf_ratio_pib")

  
  # 
  # 
  #  rename(gdp_mn_cons = `Producto interno bruto (PIB)`,
  #        fbcf = `Formación bruta de capital fijo`,
  #        fbc = `Formación bruta de capital`,
  #        fbcf_pub = `Formación bruta de capital fijo del sector público`/`Producto interno bruto (PIB)`,
  #        fbcf_pri = `Formación bruta de capital fijo del sector privado`
  #        ) %>% 
  # select(nombre_pais, year, fbcf_gdp, fbc_gdp, fbcf_pub_gdp, fbcf_pri_gdp,
  #        fbcf, fbc, fbcf_pub, fbcf_pri, gdp_mn_cons, iso2c, iso3c)
