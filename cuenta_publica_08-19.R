# Creacion de rds de Cuenta Pública 2008-2017

#### Paquetes ####
library(tidyverse)

# Notas #

# Descarga de csv desde datos abiertos de Transparencia Presupuestaria

obtener_cuenta_publica <- function(nombre) {
  read.csv(paste0("https://www.transparenciapresupuestaria.gob.mx/",
                  "/work/models/PTP/DatosAbiertos/BD_Cuenta_Publica/CSV/",
                  nombre),
    na.strings = c("#N/A", "NA"),
    stringsAsFactors = FALSE
  )
}

cp08 <- obtener_cuenta_publica("Cuenta_Publica_2008.csv")
cp09 <- obtener_cuenta_publica("Cuenta_Publica_2009.csv")
cp10 <- obtener_cuenta_publica("Cuenta_Publica_2010.csv")
cp11 <- obtener_cuenta_publica("Cuenta_Publica_2011.csv")
cp12 <- obtener_cuenta_publica("Cuenta_Publica_2012.csv")
cp13 <- obtener_cuenta_publica("cuenta_publica_2013_ra_ecd.csv")
cp14 <- obtener_cuenta_publica("cuenta_publica_2014_ra_ecd.csv")
cp15 <- obtener_cuenta_publica("cuenta_publica_2015_ra_ecd_epe.csv")
cp16 <- obtener_cuenta_publica("cuenta_publica_2016_gf_ecd_epe.csv")
cp17 <- obtener_cuenta_publica("cuenta_publica_2017_gf_ecd_epe.csv")

#### Quitar columnas innecesarias ####
cp09 <- cp09[, -c(26:40)]
cp11 <- cp11[, -c(26:42)]

# Consulta de ramos para detectar strings en lugar de integers.
cp13 %>% distinct(ID_RAMO, DESC_RAMO)
cp14 %>% distinct(ID_RAMO, DESC_RAMO)
cp15 %>% distinct(ID_RAMO, DESC_RAMO)

# Cambio de strings específicos.
cp13 <- cp13 %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYR", "50"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYN", "51"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TZZ", "52"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TOQ", "53"))) %>% 
  mutate(ID_RAMO = as.integer(ID_RAMO))

cp14 <- cp14 %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYR", "50"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYN", "51"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TZZ", "52"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TOQ", "53"))) %>% 
  mutate(ID_RAMO = as.integer(ID_RAMO))

cp15 <- cp15 %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYR", "50"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "GYN", "51"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TZZ", "52"))) %>% 
  mutate_at(vars(ID_RAMO), funs(replace(as.character(.), . == "TOQ", "53"))) %>% 
  mutate(ID_RAMO = as.integer(ID_RAMO))

# Homologar columnas con las de 2008-2012
cp13 <- cp13 %>% rename(MONTO_EJERCIDO = MONTO_EJERCICIO)
cp14 <- cp14 %>% rename(MONTO_EJERCIDO = MONTO_EJERCICIO)
cp15 <- cp15 %>% rename(MONTO_EJERCIDO = MONTO_EJERCICIO)
cp16 <- cp16 %>% rename(MONTO_EJERCIDO = MONTO_EJERCICIO)
cp17 <- cp17 %>% rename(MONTO_EJERCIDO = MONTO_EJERCICIO)

#### Unir datasets ####
cp0817 <- list(cp08, cp09, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17) %>% 
  reduce(full_join)

#### Limpiar entorno de trabajo ####
rm(list = setdiff(ls(), "cp0817"))
gc()

#### Clave RMP ####

cp0817 <- cp0817 %>% 
  mutate(RMP = paste(ID_RAMO,
                     ID_MODALIDAD,
                     sprintf("%03d", ID_PP),
                     sep = "")) %>% 
  select(CICLO, RMP, everything())

# Verificar que la clave RMP no tenga NA. Es decir, NA == 0.
sum(is.na(cp0817$RMP)) == 0

#### Guardar cuenta pública ####
saveRDS(cp0817, "data/cuenta_publica_0817.rds")

#### Descargar la cuenta desde github ####
# Nota: asegúrate de tener instalado el programa "curl". De no ser el caso, 
# puedes descargarlo desde https://curl.haxx.se/download.html donde puedes
# buscar la descarga acorde a tu sistema operativo.

githubURL <- ("https://raw.githubusercontent.com/MiguelHeCa/cuenta_publica_mx/master/data/cuenta_publica_0817.rds")
download.file(githubURL, "data/cuenta_publica.rds", method = "curl")
cp <- readRDS("data/cuenta_publica.rds")
