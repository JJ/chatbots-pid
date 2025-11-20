library(ggplot2)
library(dplyr)
library(tidyr)

frecuencias_data <- read.csv("data/frecuencias-uso-docentes.csv", header = TRUE, na.strings="", sep = ";")

columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

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

  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Frecuencia de uso ",i), x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/frecuencias-uso-docentes",i, ".png"), width = 10, height = 6)

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  print( chisq_frecuencia$p.value)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la frecuencia de uso de 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
}

