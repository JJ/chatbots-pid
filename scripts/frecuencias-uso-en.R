library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, na.strings="", sep = ";")

columnas <- strsplit("administrativas;burocracia;calendario;comunicacion-profesorado;feedback;generar-material;mejorar-calidad;preguntas-temario;preparar-examen;profesor-particular;resumen;traduccion", ";")

for ( i in columnas[[1]] ) {
  i <- gsub("-", ".", i)
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i]) %>% drop_na()

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,.data[[i]]) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("No me parece útil", "Me gustaría hacerlo", "Lo he hecho"))
  porcentajes_data$Frequency <- recode(porcentajes_data$Frecuencia,
                                       "No me parece útil" = "Not useful to me",
                                                 "Me gustaría hacerlo" = "I would like to do it",
                                                 "Lo he hecho" = "I have done it")
  
  porcentajes_data$Disciplina <- factor(porcentajes_data$Disciplina,
                                        levels = c("FFL",
                                                   "TIC",
                                                   "Otras")
  )
  porcentajes_data$Discipline <- factor(porcentajes_data$Disciplina,
                                      levels = c("FFL" = "Languages",
                                                 "TIC" = "IT",
                                                 "Otras" = "Other"))

  ggplot(porcentajes_data, aes(x=Frequency, fill=Discipline, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("How often chatbots are used for ",i), x="Frequency", y="Proportion") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    ggsave(paste0("figures/frecuencias-uso-",i, "-en.png"), width = 10, height = 6)
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la frecuencia de uso de 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
}

