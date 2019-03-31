#### Deflactor INPC ####

# Paquetes -----------------------------------------------------------------
library(jsonlite)
library(scales)
library(tidyverse)


# INPC base segunda quincela de julio 2019 = 100 --------------------------

consulta_inpc <- fromJSON(
  paste0(
    "https://www.inegi.org.mx/",
    "app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
    "628222",
    "/es/",
    "00000",
    "/false/BIE/2.0/",
    token,
    "?type=json"
  )
)

inpc_quin <- flatten_df(consulta_inpc$Series$OBSERVATIONS) %>% 
  mutate(YEAR = as.integer(str_sub(TIME_PERIOD, 1, 4)),
         MONTH = as.integer(str_sub(TIME_PERIOD, 6, 7)),
         OBS_VALUE = as.numeric(OBS_VALUE)) %>% 
  group_by(TIME_PERIOD) %>%
  mutate(DAY = row_number()) %>%
  ungroup() %>% 
  mutate(DAY = case_when(
    DAY == 1 ~ as.integer(1),
    DAY == 2 ~ as.integer(15)
  ),
  TIME_PERIOD = as.Date(paste(YEAR, MONTH, DAY, sep = "-"))) %>% 
  ungroup()

periodos_inpc <- inpc_quin %>% 
  group_by(YEAR) %>% 
  summarise(VALUES = mean(OBS_VALUE)) %>% 
  ungroup()


# Año base ----------------------------------------------------------------

base_year <- periodos_inpc %>% 
  filter(YEAR == 2018) %>% 
  select(VALUES) %>% 
  as.numeric()

factor <- periodos_inpc %>% 
  group_by(YEAR) %>% 
  transmute(FACTOR = VALUES / base_year) %>% 
  ungroup()

rm(list = c("consulta_inpc", "inpc_quin", "periodos_inpc", "base_year"))
gc()


# Exportar ----------------------------------------------------------------

write_csv(factor, "data/deflactor_base2018.csv")
