library(dplyr)
library(tidyr)
library(xts)
library(replyr)
library(wrapr)
library(mFilter)
library(stringr)
library(countrycode)
library(lubridate)
library(openxlsx)
library(ggplot2)


simple_net_growth_interval <- function(x) {
  pg <- 100*(dplyr::last(x) - dplyr::first(x)) / dplyr::first(x)
}

simple_net_growth <- function(x) {
  pg <- 100*(x - dplyr::lag(x)) / dplyr::lag(x)
}

simple_gross_growth <- function(x) {
  pg <-  x  / dplyr::lag(x)
}

geomean_growth <- function(x, input_type = "levels") {
  if (input_type == "levels") {
    len <- length(x)
    rat <- dplyr::last(x)/dplyr::first(x)
    gross_gavg_rate <- rat^(1/len)
    gavg_rate <- 100 * (gross_gavg_rate - 1)
    return(gavg_rate)
  }
  if (input_type == "gross_rates") {
    len <- length(x)
    cum_growth = dplyr::last(cumprod(x))
    gross_gavg_rate <- cum_growth^(1/len)
    gavg_rate <- 100 * (gross_gavg_rate - 1)
    return(gavg_rate)
  } 
  
}


growth_report <- function(df, input_type = "levels", this_region_name = "", 
                          start1 = 2003, end1 = 2008,
                          start2 = 2010, end2 = 2015) {

  if (input_type == "levels") {
    new_df <- df %>% 
      arrange(eco_id, date_id) %>% 
      group_by(eco_id) %>% 
      mutate(ptp_net_gr = simple_net_growth(voi),
             ptp_gross_gr = simple_gross_growth(voi)) %>% 
      ungroup()
  }
  
  if (input_type == "gross_rates") {
    new_df <- df %>% 
      arrange(eco_id, date_id) %>% 
      group_by(eco_id) %>% 
      mutate(ptp_net_gr = 100 * (voi - 1),
             ptp_gross_gr = voi) %>% 
      ungroup()
  }

  new_df_per1 <-  new_df %>%
    filter(year(date_id) >= start1 & year(date_id) <= end1) %>% 
    group_by(eco_id) %>% 
    summarise(ari_mean_gr_per1 = mean(ptp_net_gr, na.rm = TRUE),
              geo_mean_gr_per1 = geomean_growth(voi, input_type = input_type))
    
  new_df_per2 <-  new_df %>%
    filter(year(date_id) >= start2 & year(date_id) <= end2) %>% 
    group_by(eco_id) %>% 
    summarise(ari_mean_gr_per2 = mean(ptp_net_gr, na.rm = TRUE),
              geo_mean_gr_per2 = geomean_growth(voi, input_type = input_type))
  
  means_two_periods <- left_join(new_df_per1 , new_df_per2,
                                 by = "eco_id") %>% 
    mutate(change_ari = ari_mean_gr_per2 - ari_mean_gr_per1,
           change_geo = geo_mean_gr_per2 - geo_mean_gr_per1,
           dif_sign_g_vs_a = change_ari*change_geo < 0) %>% 
    arrange(desc(change_geo))
  
  two_per_stats <- means_two_periods %>% 
    summarise(neg_change_geo = sum(change_geo < 0),
              neg_change_ari = sum(change_ari < 0),
              n_dif_geo_ari = sum(dif_sign_g_vs_a))
  
  neg_geo_change_ids  <- means_two_periods %>% 
    filter(change_geo < 0)  %>% 
    select(eco_id)
  
  
  pos_geo_change_ids  <- means_two_periods %>% 
    filter(change_geo > 0)  %>% 
    select(eco_id)
  
  
  neg_ari_change_ids  <- means_two_periods %>% 
    filter(change_ari < 0)  %>% 
    select(eco_id)
  
  
  pos_ari_change_ids  <- means_two_periods %>% 
    filter(change_ari > 0)  %>% 
    select(eco_id)
  
  
  group_avgs <- means_two_periods %>%
    summarise_at(c("ari_mean_gr_per1","geo_mean_gr_per1",
                   "ari_mean_gr_per2","geo_mean_gr_per2"), mean) %>% 
    mutate(change_ari = ari_mean_gr_per2 - ari_mean_gr_per1,
           change_geo = geo_mean_gr_per2 - geo_mean_gr_per1,
           region_name = this_region_name)


  return(list(new_df = new_df, avgs_df = means_two_periods,
              neggeochg = neg_geo_change_ids, posgeochg = pos_geo_change_ids, 
              negarichg = neg_ari_change_ids, posarichg = pos_geo_change_ids,
              other_stats = two_per_stats,
              group_averages = group_avgs))
  }


means_report <- function(df,  
                          start1 = 2003, end1 = 2008,
                          start2 = 2010, end2 = 2015) {
  
  new_df <- df %>% 
      arrange(eco_id, date_id) 
  
  new_df_per1 <-  new_df %>%
    filter(year(date_id) >= start1 & year(date_id) <= end1) %>% 
    group_by(eco_id) %>% 
    summarise(mean_per1 = mean(voi, na.rm = TRUE)
              )
  
  new_df_per2 <-  new_df %>%
    filter(year(date_id) >= start2 & year(date_id) <= end2) %>% 
    group_by(eco_id) %>% 
    summarise(mean_per2 = mean(voi, na.rm = TRUE)
              )
  
  means_two_periods <- left_join(new_df_per1 , new_df_per2,
                                 by = "eco_id") %>% 
    mutate(change = mean_per2 - mean_per1,
           change_pct = 100* (change/mean_per1)-1
           ) %>% 
    arrange(desc(change_pct))
  
  two_per_stats <- means_two_periods %>% 
    summarise(neg_change = sum(change < 0))
  
  neg_change_ids  <- means_two_periods %>% 
    filter(change < 0)  %>% 
    select(eco_id)
  
  
  pos_change_ids  <- means_two_periods %>% 
    filter(change > 0)  %>% 
    select(eco_id)
  

  group_avgs <- means_two_periods %>%
    summarise_at(c("mean_per1","mean_per2"), mean) %>% 
    mutate(change = mean_per2 - mean_per1)
  
  
  return(list(new_df = new_df, avgs_df = means_two_periods,
              negchg = neg_change_ids, poschg = pos_change_ids,
              other_stats = two_per_stats,
              group_averages = group_avgs))
}



add_ts_filters <- function(df, date_colname = "date", value_colname = "value",
                           hp_type = "lambda", data_periodicity = "annual",
                           country_colname = "iso"){
  
  df$hp_cycle <- NA
  df$hp_trend <- NA
  df$hp_cycle_pct <- NA
  
  df$cf_cycle <- NA
  df$cf_trend <- NA
  df$cf_cycle_pct <- NA
  
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
    
    co_cf = cffilter(co_xts, pl = 2, pu=15, root = TRUE)
    df$cf_cycle[df[[country_colname]] == co] <- co_cf$cycle
    df$cf_trend[df[[country_colname]] == co] <- co_cf$trend
    df$cf_cycle_pct[df[[country_colname]] == co] <- 100 * co_cf$cycle/co_cf$trend
    
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


multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

