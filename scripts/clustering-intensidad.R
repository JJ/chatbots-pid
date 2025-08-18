library(ggplot2)
library(dplyr)
library(tidyverse)

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, na.strings="", sep = ";")
frecuencias_data$mejorar.calidad <- NULL # Since we don't have data for some


intensidad_vectores <- frecuencias_data %>%
  mutate(across(-Disciplina, ~ recode(.x, `No me parece útil` = 0, `Me gustaría hacerlo` = 1, `Lo he hecho` = 2)))

# cluster all vectores in intensidad_vectores, using "Disciplina" as a class label

intensidad_vectores <- intensidad_vectores %>%
  select(-Disciplina) %>%
  as.matrix()

clusters <- kmeans(intensidad_vectores, centers = 3, nstart = 25)

# reorganize cluster$centers in three columns, the first column will have the center number, the second the order of the column and the third the value of that element of the center

centers_df <- as.data.frame(clusters$centers)
# convert the "Variable" column values to values from 1 to 11 according to order
centers_to_plot <- centers_df %>%
  mutate(Center = row_number()) %>%
  pivot_longer(-Center, names_to = "Variable", values_to = "Value") %>%
  mutate(across(Variable, recode,
                  `administrativas` = 1,
                  `burocracia` = 2,
                  `calendario` = 3,
                  `comunicacion.profesorado` = 4,
                  `feedback` = 5,
                  `generar.material` = 6,
                  `preguntas.temario` = 7,
                  `preparar.examen` = 8,
                  `profesor.particular` = 9,
                  `resumen` = 10,
                  `traduccion` = 11)) %>%
  arrange(Center, Variable)

ggplot(centers_to_plot, aes(x = Variable, y = Value, group=Center,color= Center)) +
  geom_line() +
  geom_point() +
  labs(title = "Centroides de los clusters de intensidad", x = "Índice de la variable", y = "Valor del centroide") +
  theme_minimal()
ggsave("figures/centroides-clusters-intensidad.png", width = 10, height = 6)
