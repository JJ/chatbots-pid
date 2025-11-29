library(ggplot2)
library(dplyr)
library(tidyverse)
library(factoextra)

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
                "ayudan" = 1, "dependencia.tecnológica" = 8, "explicaciones.claras" = 3, "información.segura" = 11, "manejan.datos" = 5, "mejorar.habilidades"=2,"no.pensamiento.crítico"=9,"no.respetan.privacidad"=10,"parte.integral"=7,"respuestas.confiables"=4,"ético"=6)) %>%
  arrange(Center, Variable)

ggplot(centers_to_plot, aes(x = as.factor(Variable), y = Value, group=Center,color= as.factor(Center))) +
  geom_line() +
  geom_point() +
  labs(title = "Centroids of the opinion clusters", y = "Centroide value") +
  scale_x_discrete(name="Opinions",
                   labels = c("1"="Helpful",
                              "8"="Tech cependence",
                              "3"= "Clear explanation",
                              "11"="Biased information",
                              "5"= "Sensitive data",
                              "2"="Improve skills",
                              "9"="Lack of critical thinking",
                              "10"="Disrespectful of privacy",
                              "7"="Integral part of education",
                              "4"="Reliable answers",
                              "6"="Ethical issues")) +
  theme_minimal()+
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=10, angle=45))+
  guides(color=guide_legend(title="Cluster #"))

ggsave("figures/centroides-clusters-opiniones-en.png", width = 10, height = 6)

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
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(color=guide_legend(title="Cluster #"))
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

cantidad_cluster_por_disciplina$Discipline <- recode(cantidad_cluster_por_disciplina$Disciplina,
                                         "FFL" = "Languages",
                                         "TIC" = "IT",
                                         "Otras" = "Other")
ggplot(cantidad_cluster_por_disciplina, aes(x=Cluster, fill=Discipline, y = Cantidad)) +
  geom_bar( stat="identity", position="stack") +
  labs(title="Distribution per cluster and discipline", x="Cluster", y="Quantity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/cantidad-cluster-por-disciplina-opiniones-en.png", width = 10, height = 6)
