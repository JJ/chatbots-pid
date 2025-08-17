library(ggplot2)
library(dplyr)
library(tidyverse)

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, na.strings="", sep = ";")
frecuencias_data_intensidad <- read.csv("data/frecuencias.csv", header = TRUE, sep = ";")
columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;mejorar-calidad;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

frecuencias_data$Frecuencia <- frecuencias_data_intensidad$Frecuencia

for ( i in columnas[[1]] ) {
  # Change _ in i to .
  i <- gsub("-", ".", i)
  frecuencias_uso_data  <-  data.frame(Frecuencia = frecuencias_data$Frecuencia,
                                       frecuencias_data[i]) %>% drop_na()

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Frecuencia,.data[[i]]) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data$Frecuencia,
                                        levels = c( "Nunca", "Casi nunca", "A veces", "Casi siempre", "Siempre"))

  porcentajes_data$Uso <- factor(porcentajes_data[[i]],
                                 levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))

  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Uso, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Empleo en diferentes aplicaciones ",i), x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/frecuencia-uso-vs-aplicacion-",i, ".png"), width = 10, height = 6)

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Frecuencia)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la frecuencia de uso de 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }

  ggplot(porcentajes_data, aes(x=Uso, fill=Frecuencia, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Empleo en diferentes aplicaciones por utilidad percibida ",i), x="Uso", y="Proporción") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/empleo-vs-utilidad-",i, ".png"), width = 10, height = 6)

}

