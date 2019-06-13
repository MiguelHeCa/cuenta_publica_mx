# Agregando ramos de 1995 a 2007

cp_97_07 <- read.csv("data/cuenta_publica_96-07.csv",
                     stringsAsFactors = F)

cp_08_18 <- read.csv("data/ramos.csv", stringsAsFactors = F)

library(tidyverse)

cp_97_18 <- cp_97_07 %>% 
  select(-MONTO_ORIGINAL) %>% 
  rename(EJERCIDO_MDP = MONTO_EJERCIDO) %>% 
  full_join(cp_08_18) %>% 
  as.tbl()

write_csv(cp_97_18, "data/ramos_95_18.csv")
