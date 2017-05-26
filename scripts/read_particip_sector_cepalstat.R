library(readxl)

parti_por_tipo_de_actividad <- read_excel("./raw_data/parti_por_tipo_de_actividad.xlsx",
sheet = "tidier", col_types = c("text",
"text", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "skip"))
save(parti_por_tipo_de_actividad,  file = "./produced_data/cs_particip_pib_actividad")

parti_x_manuf <- read_excel("./raw_data/parti_x_manuf.xlsx",
sheet = "tidier", col_types = c("text",
"numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "numeric", "numeric", "numeric", "numeric",
"numeric", "skip"))
save(parti_x_manuf,  file = "./produced_data/cs_particip_x_manuf")

parti_x_primarios <- read_excel("./raw_data/parti_x_primarios.xlsx",
                            sheet = "tidier", col_types = c("text",
                                                            "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric", "numeric", "numeric", "numeric", "numeric",
                                                            "numeric"))
save(parti_x_primarios,  file = "./produced_data/cs_particip_x_primarios")







