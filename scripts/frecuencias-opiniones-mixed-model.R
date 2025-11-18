library(ggplot2)
library(dplyr)
library(ordinal)

frecuencias_data <- read.csv("data/actitudes-género.csv", header = TRUE, na.strings="", sep = ";")
columnas <- strsplit("ayudan;dependencia-tecnológica;explicaciones-claras;información-segura;manejan-datos;mejorar-habilidades;no-pensamiento-crítico;no-respetan-privacidad;parte-integral;respuestas-confiables;ético", ";")
frecuencias_data <- frecuencias_data %>% filter(Género != "Prefiero no decirlo")

for ( i in columnas[[1]] ) {
  i <- gsub("-", ".", i)
  frecuencias_opinion_data  <-  data.frame(Genero = frecuencias_data$Género,
                                       Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  frecuencias_opinion_data$Disciplina <- factor(frecuencias_opinion_data$Disciplina)
  frecuencias_opinion_data$Genero <- factor(frecuencias_opinion_data$Genero)

  frecuencias_opinion_data$likert <- as.numeric( factor( unname(unlist(frecuencias_opinion_data[i])),
                                            levels = c("Estoy en desacuerdo", "Más bien en desacuerdo","Ni estoy de acuerdo ni en desacuerdo", "Más bien de acuerdo", "Completamente de acuerdo" )
                                            )
                                      )
  frecuencias_opinion_data$likert_factor <- factor( frecuencias_opinion_data$likert)
  model <-  model <- clm( likert_factor ~ Genero + Disciplina, data=frecuencias_opinion_data, link="logit" )
  coefs <- summary(model)$coefficients

  high_pval <- coefs[coefs[, "Pr(>|z|)"] <= 0.05, , drop = FALSE]
  # Filter high_pval to only include rows where row names contain "Genero" or "Disciplina"
  coefficients <- high_pval[grep("Genero|Disciplina", rownames(high_pval)), , drop = FALSE]

  # print only if coefficients is not empty
  if ( nrow(coefficients) > 0 ) {
    print("========================================")
    print("Significant coefficients for variable:")
    print(i)
    print(coefficients)
  }

}
