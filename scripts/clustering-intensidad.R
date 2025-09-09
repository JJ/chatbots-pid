library(ggplot2)
library(dplyr)
library(tidyverse)
library(factoextra)

# Lleva a cabo un clustering de las respuestas a las preguntas sobre aplicaciones

frecuencias_data <- read.csv("data/frecuencias-uso.csv", header = TRUE, na.strings="", sep = ";")
frecuencias_data$mejorar.calidad <- NULL # Since we don't have data for some

intensidad_vectores <- frecuencias_data %>%
  mutate(across(-Disciplina, ~ recode(.x, `No me parece útil` = 0, `Me gustaría hacerlo` = 1, `Lo he hecho` = 2)))

intensidad_vectores <- intensidad_vectores %>%
  select(-Disciplina)

fviz_nbclust(intensidad_vectores, kmeans, method = "wss")
ggsave("figures/nb-clusters-intensidad.png", width = 10, height = 6)
clusters <- kmeans(intensidad_vectores, centers = 3, nstart = 25)

# reorganize cluster$centers in three columns, the first column will have the center number, the second the order of the column and the third the value of that element of the center

centers_df <- as.data.frame(clusters$centers)
# convert the "Variable" column values to values from 1 to 11 according to order
centers_to_plot <- centers_df %>%
  mutate(Center = row_number()) %>%
  pivot_longer(-Center, names_to = "Variable", values_to = "Value") %>%
  mutate(across(Variable, recode,
                  `administrativas` = 8,
                  `burocracia` = 9,
                  `calendario` = 10,
                  `comunicacion.profesorado` = 11,
                  `feedback` = 4,
                  `generar.material` = 5,
                  `preguntas.temario` = 1,
                  `preparar.examen` = 2,
                  `profesor.particular` = 3,
                  `resumen` = 6,
                  `traduccion` = 7)) %>%
  arrange(Center, Variable)

ggplot(centers_to_plot, aes(x = as.factor(Variable), y = Value, group=Center,color= as.factor(Center))) +
  geom_line() +
  geom_point() +
  labs(title = "Centroides de los clusters de intensidad", y = "Valor del centroide") +
  scale_x_discrete(name="Aplicación", labels = c("8" ="Admin. asignatura", "9"="Burocracia",
                              "10"="Calendario", "11"="Comunicación prof.",
                                                        "4"="Feedback", "5"="Generar material",
                              "1"="Preguntas del temario",
                                                        "2"="Preparar examen", "3"="Profesor particular", "6"="Resumen", "7"="Traducción")) +
  theme_minimal()+
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=10, angle=45))

ggsave("figures/centroides-clusters-intensidad.png", width = 10, height = 6)

frecuencias_data$Cluster <- as.factor(clusters$cluster)

frecuencias_data %>% group_by( Cluster, Disciplina ) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número)) -> porcentaje_disciplina_por_cluster

ggplot(porcentaje_disciplina_por_cluster, aes(x=Cluster, fill=Disciplina, y = Proporción)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Proporción de disciplinas por cluster de intensidad", x="Cluster", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/porcentaje-disciplinas-por-cluster-intensidad.png", width = 10, height = 6)

frecuencias_data %>% group_by( Disciplina, Cluster ) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número)) -> porcentaje_cluster_por_disciplina

ggplot(porcentaje_cluster_por_disciplina, aes(x=Disciplina, fill=Cluster, y = Proporción)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Proporción de clusters para cada disciplina", x="Disciplina", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/porcentaje-cluster-por-disciplina-intensidad.png", width = 10, height = 6)

frecuencias_data %>% group_by( Cluster, Disciplina ) %>%
  summarise(Número = n()) %>%
  mutate(Cantidad = Número ) -> cantidad_cluster_por_disciplina

cantidad_cluster_por_disciplina$Disciplina <- factor(cantidad_cluster_por_disciplina$Disciplina,
                                      levels = c("FFL",
                                                 "TIC",
                                                 "Otras")
)
ggplot(cantidad_cluster_por_disciplina, aes(x=Cluster, fill=Disciplina, y = Cantidad)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Cantidad en cada cluster por disciplina", x="Cluster", y="Cantidad") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/cantidad-cluster-por-disciplina-intensidad.png", width = 10, height = 6)
