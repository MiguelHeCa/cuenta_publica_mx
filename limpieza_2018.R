# Leer cuenta púplica 2018

library(tidyverse)

# Descarga de csv desde datos abiertos de Transparencia Presupuestaria

# Obtener csv -------------------------------------------------------------

obtener_cuenta_publica <- function(nombre) {
  read.csv(paste0("https://www.transparenciapresupuestaria.gob.mx/",
                  "/work/models/PTP/DatosAbiertos/BD_Cuenta_Publica/CSV/",
                  nombre),
           na.strings = c("#N/A", "NA"),
           stringsAsFactors = FALSE,
           fileEncoding = "latin1"
  )
}

cp18 <- obtener_cuenta_publica("cuenta_publica_2019_gf_ecd_epe.csv")

# Estandarizar formato con años anteriores --------------------------------

cp18_arreglado <- cp18 %>% 
  mutate(RMP = paste0(
    sprintf("%02d", R),
    M,
    sprintf("%03d", PP)
  )) %>% 
  select(Ciclo, RMP, R:FF_descripción, Original, Ejercicio, EF:PPI, Modificado:Adefas) %>% 
  arrange(R, M, PP) %>% 
  rename_all(.funs = toupper) %>% 
  mutate_at(c("PAGADO", "EJERCICIO"), parse_number) %>% 
  rename(ID_RAMO = R,
         DESC_RAMO = R_DESCRIPCIÓN,
         ID_UR = UR,
         DESC_UR = UR_DESCRIPCIÓN,
         GPO_FUNCIONAL = FI,
         DESC_GPO_FUNCIONAL = FI_DESCRIPCIÓN,
         ID_FUNCION = FU,
         DESC_FUNCION = FU_DESCRIPCIÓN,
         ID_SUBFUNCION = SF,
         DESC_SUBFUNCION = SF_DESCRIPCIÓN,
         ID_AI = AI,
         DESC_AI = AI_DESCRIPCIÓN,
         ID_MODALIDAD = M,
         DESC_MODALIDAD = M_DESCRIPCIÓN,
         ID_PP = PP,
         DESC_PP = PP_DESCRIPCIÓN,
         ID_OBJETO_DEL_GASTO = PTDA,
         DESC_OBJETO_DEL_GASTO = PTDA_DESCRIPCIÓN,
         ID_TIPOGASTO = TG,
         DESC_TIPOGASTO = TG_DESCRIPCIÓN,
         ID_FF = FF,
         DESC_FF = FF_DESCRIPCIÓN,
         MONTO_APROBADO = ORIGINAL,
         MONTO_EJERCIDO = EJERCICIO,
         ID_ENTIDAD_FEDERATIVA = EF,
         ENTIDAD_FEDERATIVA = EF_DESCRIPCIÓN,
         ID_CLAVE_CARTERA = PPI,
         MONTO_MODIFICADO = MODIFICADO,
         MONTO_DEVENGADO = DEVENGADO,
         MONTO_PAGADO = PAGADO,
         MONTO_ADEFAS = ADEFAS)

# Agregar a los ciclos anteriores -----------------------------------------

cp_08_17 <- readRDS("data/cuenta_publica_0817.rds")

cp_08_18 <- cp_08_17 %>% 
  full_join(cp18_arreglado)

# Guardar nuevo rds -------------------------------------------------------

saveRDS(cp_08_18, "data/cuenta_publica_0818.rds")
