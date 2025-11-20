library(ggplot2)
library(dplyr)
library(tidyr)

frecuencias_data <- read.csv("data/frecuencias-uso-docentes.csv", header = TRUE, na.strings="", sep = ";")

columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

resultados_uso <- data.frame( uso=character(),
                              frecuencia=character(),
                              porcentaje = numeric() );

for ( i in columnas[[1]] ) {
  i <- gsub("-", ".", i)

  porcentajes_data <-  frecuencias_data[i] %>% drop_na() %>% group_by(.data[[i]]) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                        levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))

  for (j in levels(porcentajes_data$Frecuencia) ) {
    resultados_uso <- rbind( resultados_uso,
                             data.frame( uso = i,
                                         frecuencia = j,
                                         porcentaje = sum( porcentajes_data$Proporción[porcentajes_data$Frecuencia == j] )
                             )
    )
  }

}

resultados_uso$uso <- factor(resultados_uso$uso,
                             levels = resultados_uso %>%
                               filter(frecuencia == "Lo he hecho") %>%
                               arrange(porcentaje) %>% pull(uso)
                             )
ggplot(resultados_uso, aes(x=uso, fill=frecuencia, y = porcentaje)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso de diferentes aplicaciones por docentes", x="Aplicación", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(paste0("figures/frecuencias-uso-docentes.png"), width = 10, height = 6)
