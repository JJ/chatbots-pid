library(ggplot2)
library(dplyr)

# Analiza los datos relativos a las actitudes y opiniones

frecuencias_data <- read.csv("data/actitudes.csv", header = TRUE, na.strings="", sep = ";")

columnas <- strsplit("ayudan;dependencia-tecnológica;explicaciones-claras;información-segura;manejan-datos;mejorar-habilidades;no-pensamiento-crítico;no-respetan-privacidad;parte-integral;respuestas-confiables;ético", ";")

for ( i in columnas[[1]] ) {
  # Change _ in i to .
  i <- gsub("-", ".", i)
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,.data[[i]]) %>%
    summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("Estoy en desacuerdo", "Más bien en desacuerdo","Ni estoy de acuerdo ni en desacuerdo", "Más bien de acuerdo", "Completamente de acuerdo" ))

  porcentajes_data$Disciplina <- factor(porcentajes_data$Disciplina,
                                        levels = c("FFL",
                                                   "TIC",
                                                   "Otras")
  )

  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Actitud sobre ",i), x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/actitudes-",i, ".png"), width = 10, height = 6)

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la actitud 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
}

