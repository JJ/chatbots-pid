library(ggplot2)
library(dplyr)
library(tidyverse)
library(factoextra)

# Lleva a cabo un clustering de las respuestas a las preguntas sobre opiniones

frecuencias_data <- read.csv("data/actitudes.csv", header = TRUE, na.strings="", sep = ";")

opiniones_vectores <- frecuencias_data %>%
  mutate(across(-Disciplina, ~ recode(.x, "Estoy en desacuerdo" = -2, "Más bien en desacuerdo" = -1,"Ni estoy de acuerdo ni en desacuerdo" = 0, "Más bien de acuerdo" = 1, "Completamente de acuerdo" = 2)))

opiniones_vectores <- opiniones_vectores %>%
  select(-Disciplina)

correlacion <- cor(opiniones_vectores)
fviz_nbclust(opiniones_vectores, kmeans, method = "wss")
clusters <- kmeans(opiniones_vectores, centers = 3, nstart = 25)

centers_df <- as.data.frame(clusters$centers)
centers_to_plot <- centers_df %>%
  mutate(Center = row_number()) %>%
  pivot_longer(-Center, names_to = "Variable", values_to = "Value") %>%
  mutate(across(Variable, recode,
                "ayudan" = 1, "dependencia.tecnológica" = 2, "explicaciones.claras" = 3, "información.segura" = 4, "manejan.datos" = 5, "mejorar.habilidades"=6,"no.pensamiento.crítico"=7,"no.respetan.privacidad"=8,"parte.integral"=9,"respuestas.confiables"=10,"ético"=11)) %>%
  arrange(Center, Variable)

ggplot(centers_to_plot, aes(x = as.factor(Variable), y = Value, group=Center,color= as.factor(Center))) +
  geom_line() +
  geom_point() +
  labs(title = "Centroides de los clusters de opiniones", y = "Valor del centroide") +
  scale_x_discrete(name="Aplicación",
                   labels = c("1"="Ayudan",
                              "2"="Dependencia tecnológica",
                              "3"= "Explicaciones claras",
                              "4"="Información segura",
                              "5"= "manejan.datos",
                              "6"="mejorar habilidades",
                              "7"="No pensamiento crítico",
                              "8"="No respetan privacidad",
                              "9"="Parte integral",
                              "10"="respuestas.confiables",
                              "11"="Ético")
                   ) +
  theme_minimal()+
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=10, angle=45))

ggsave("figures/centroides-clusters-opiniones.png", width = 10, height = 6)

frecuencias_data$Cluster <- as.factor(clusters$cluster)

frecuencias_data %>% group_by( Cluster, Disciplina ) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número)) -> porcentaje_disciplina_por_cluster

porcentaje_disciplina_por_cluster$Disciplina <- factor(porcentaje_disciplina_por_cluster$Disciplina,
                                                levels = c("FFL",
                                                  "TIC",
                                                  "Otras")
)

ggplot(porcentaje_disciplina_por_cluster, aes(x=Cluster, fill=Disciplina, y = Proporción)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Proporción de disciplinas por cluster de intensidad", x="Cluster", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/porcentaje-disciplinas-por-cluster-opiniones.png", width = 10, height = 6)

frecuencias_data %>% group_by( Disciplina, Cluster ) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número)) -> porcentaje_cluster_por_disciplina

ggplot(porcentaje_cluster_por_disciplina, aes(x=Disciplina, fill=Cluster, y = Proporción)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Proporción de clusters para cada disciplina", x="Disciplina", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/porcentaje-cluster-por-disciplina-opiniones.png", width = 10, height = 6)

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
ggsave("figures/cantidad-cluster-por-disciplina-opiniones.png", width = 10, height = 6)
