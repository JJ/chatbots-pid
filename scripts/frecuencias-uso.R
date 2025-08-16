library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, sep = ";")

# SPLIT administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;mejorar-calidad;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion by ";"

columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;mejorar-calidad;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

for ( i in columnas ) {
  # create a dataframe with the discipline and the content of the column i
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       Frecuencia = frecuencias_data[i])

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,Frecuencia) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data$Frecuencia,
                                      levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))

  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title="Frecuencia de uso", x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("frecuencias-uso-",i, ".png"), width = 10, height = 6)
}
frecuencia_tabla <- table( frecuencias_data$Frecuencia, frecuencias_data$Disciplina)
chisq_frecuencia <- chisq.test(frecuencia_tabla)
