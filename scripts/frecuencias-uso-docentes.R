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
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i]) %>% drop_na()

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,.data[[i]]) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))
  porcentajes_data$Disciplina <- factor(porcentajes_data$Disciplina,
                                        levels = c("TIC",
                                                   "Otras")
                                       )

  for (j in levels(porcentajes_data$Frecuencia) ) {
    resultados_uso <- rbind( resultados_uso,
                             data.frame( uso = i,
                                         frecuencia = j,
                                         porcentaje = sum( porcentajes_data$Proporción[porcentajes_data$Frecuencia == j] )
                             )
    )
  }

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  print( chisq_frecuencia$p.value)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la frecuencia de uso de 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
}

ggplot(resultados_uso, aes(x=uso, fill=frecuencia, y = porcentaje)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso de diferentes aplicaciones por docentes", x="Aplicación", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(paste0("figures/frecuencias-uso-docentes.png"), width = 10, height = 6)
