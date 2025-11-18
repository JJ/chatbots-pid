library(ggplot2)
library(dplyr)


frecuencias_data <- read.csv("data/actitudes-género.csv", header = TRUE, na.strings="", sep = ";")
columnas <- strsplit("ayudan;dependencia-tecnológica;explicaciones-claras;información-segura;manejan-datos;mejorar-habilidades;no-pensamiento-crítico;no-respetan-privacidad;parte-integral;respuestas-confiables;ético", ";")
frecuencias_data <- frecuencias_data %>% filter(Genero != "Prefiero no decirlo")

for ( i in columnas[[1]] ) {
  i <- gsub("-", ".", i)
  frecuencias_uso_data  <-  data.frame(Genero = frecuencias_data$Género,
                                       Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Género)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa por género en la actitud 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa por disciplina en la actitud 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), interaction(frecuencias_data$Disciplina, frecuencias_data$Género))
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa por disciplina en la actitud 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }

}
