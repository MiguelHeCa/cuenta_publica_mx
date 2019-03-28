# cuenta_publica_mx
Repositorio de la cuenta pública federal de 2008 a 2017

Actualmente la cuenta pública se presenta en [Transparencia presupuestaria](https://www.transparenciapresupuestaria.gob.mx/), en donde se pueden encontrar [indicadores de desempeño](https://www.transparenciapresupuestaria.gob.mx/es/PTP/programas), resumen del [uso del presupuesto](https://www.transparenciapresupuestaria.gob.mx/es/PTP/Presupuesto) y, por supuesto, [información desagregada](https://www.transparenciapresupuestaria.gob.mx/es/PTP/Datos_Abiertos) del gasto ejercido del gobierno federal mexicano.

Si bien los datos que suben son accesibles y ya están (en su mayor parte) suficientemente limpios para trabajarlos, están publicados en un solo año. La razón de esto no es trivial. Juntar los años de 2008 a 2017 hacen que el `csv` pese aprox. 1GB. Sin embargo, bajarlos uno por uno es un dolor de cabeza. Existe la API para acceder a ello, pero por el momento este repositorio se encargará de contenter la cuenta pública en un solo archivo `rds`.

Transparencia presupuestaria publica la información necesaria para entender la cuenta pública en el [catálogo presupuestario](https://www.transparenciapresupuestaria.gob.mx/work/models/PTP/DatosAbiertos/Metadatos/catalogos_presupuestarios.xlsx) y en el [Diccionario Avance Financiero](https://www.transparenciapresupuestaria.gob.mx/work/models/PTP/DatosAbiertos/Metadatos/Metadatos_Avance_Financiero.xlsx). 

Aunque se agradece que es pública la información, a veces es difícil de seguir el hilo del significado de esta información. Tal vez en un futuro haga un wiki al respecto.
