#### PIB ####

# Paquetes ----------------------------------------------------------------

library(jsonlite)
library(scales)
library(tidyverse)


# PIB a precios corrientes ------------------------------------------------

consulta_pib <- fromJSON(
  paste0(
    "https://www.inegi.org.mx/",
    "app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
    "493717",
    "/es/",
    "00000",
    "/false/BIE/2.0/",
    token,
    "?type=json"
  )
)

pib_corriente <- flatten_df(consulta_pib$Series$OBSERVATIONS) %>% 
  mutate(YEAR = as.integer(str_sub(TIME_PERIOD, 1, 4)),
         MONTH = as.integer(str_sub(TIME_PERIOD, 6, 7)),
         DAY = as.integer(1),
         OBS_VALUE = as.numeric(OBS_VALUE),
         TIME_PERIOD = as.Date(paste(YEAR, MONTH, DAY, sep = "-")))

pib_anual <- pib_corriente %>% 
  group_by(YEAR) %>% 
  summarise(PIB_CORRIENTE = mean(OBS_VALUE))

rm(list = c("consulta_pib", "pib_corriente"))
gc()


# Exportar ----------------------------------------------------------------

write_csv(pib_anual, "data/pib_corr_anual.csv")