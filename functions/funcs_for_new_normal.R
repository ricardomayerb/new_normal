library(dplyr)
library(tidyr)
library(xts)
library(replyr)
library(wrapr)
library(mFilter)
library(stringr)
library(countrycode)




add_ts_filters <- function(df, date_colname = "date", value_colname = "value",
                           hp_type = "lambda", data_periodicity = "annual",
                           country_colname = "iso"){
  
  df$hp_cycle <- NA
  df$hp_trend <- NA
  df$hp_cycle_pct <- NA
  
  if(data_periodicity == "annual"){
    lambda_value = 6.25
  } else {
    if(data_periodicity == "quarterly"){
      lambda_value = 1600
    } else{
      if (data_periodicity == "monthly") {
        lambda_value = 129600
      }
    }
  }
  
  for (co in unique(df[[country_colname]])) {
    co_data = df[df[[country_colname]] == co, ]
    co_xts = xts(co_data[[value_colname]], order.by = co_data[[date_colname]])
    
    co_hp = hpfilter(co_xts,  type = "lambda", freq = lambda_value)
    
    
    df$hp_cycle[df[[country_colname]] == co] <- co_hp$cycle
    df$hp_trend[df[[country_colname]] == co] <- co_hp$trend
    df$hp_cycle_pct[df[[country_colname]] == co] <- 100 * co_hp$cycle/co_hp$trend
    
  }
 
  return(df)
}



add_iso <- function(df, names_col, dict, lang="es", rm_nf = FALSE) {
  
  
  if (any(str_detect("Años", names(df)))) {
    
    names(df) <- str_replace_all(names(df), "Años","year")
    
  }
  
  if (lang == "es") {
    ori <-  "country.name.es"
    new_names_col <- "nombre_pais"
    
  } else {
    ori = "country.name.en"
    new_names_col <- "country_name"
  }
  
  
  wrapr::let(
    alias = list(names_col = names_col, new_names_col = new_names_col),
    expr = {
      df <- df %>% 
        mutate(iso3c = countrycode(df[["names_col"]],
                                   custom_dict = dict,
                                   origin = ori,
                                   destination = "iso3c"),
               iso2c = countrycode(df[["names_col"]],
                                   custom_dict = dict,
                                   origin = ori,
                                   destination = "iso2c")
        ) %>% 
        filter(!is.na(iso3c)) %>% 
        rename(new_names_col = names_col)
    })
  
  if (rm_nf) {
    df <- df %>% select(-c(fuente, notas))
  }
  
  
  return(df)
}
