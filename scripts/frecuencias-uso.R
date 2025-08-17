library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, sep = ";")


columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;mejorar-calidad;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

for ( i in columnas[[1]] ) {
  # Change _ in i to .
  i <- gsub("-", ".", i)
  cat("Procesando disciplina:", i, "\n")
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,.data[[i]]) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))

  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Frecuencia de uso ",i), x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/frecuencias-uso-",i, ".png"), width = 10, height = 6)
}
frecuencia_tabla <- table( frecuencias_data$Frecuencia, frecuencias_data$Disciplina)
chisq_frecuencia <- chisq.test(frecuencia_tabla)
