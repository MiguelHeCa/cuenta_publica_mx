library(tidyverse)


cp <- readRDS("data/cuenta_publica.rds")

saveRDS(cp, "data/cuenta_publica_0817.rds")

# Cuenta pública por ramo
ramos <- cp %>% 
  group_by(CICLO, ID_RAMO, DESC_RAMO) %>% 
  summarise(EJERCIDO_MPD = sum(MONTO_EJERCIDO) / 1000000)

# Cuenta pública por modalidad
modalidad <- cp %>% 
  group_by(CICLO, ID_RAMO, DESC_RAMO, ID_MODALIDAD, DESC_MODALIDAD) %>% 
  summarise(EJERCIDO_MPD = sum(MONTO_EJERCIDO) / 1000000)

# Cuenta pública por programa presupuestario
prog_pres <- cp %>% 
  group_by(CICLO,
           RMP,
           ID_RAMO,
           DESC_RAMO,
           ID_MODALIDAD,
           DESC_MODALIDAD,
           ID_PP,
           DESC_PP) %>% 
  summarise(EJERCIDO_MPD = sum(MONTO_EJERCIDO) / 1000000)

# Escribirlo a csv
write_csv(ramos, "data/ramos.csv")
write_csv(modalidad, "data/modalidad.csv")
write_csv(prog_pres, "data/prog_pres.csv")
