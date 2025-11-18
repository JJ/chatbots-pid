library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/mejora-trabajos.csv", header = TRUE, sep = ";")

porcentajes_data <-  frecuencias_data %>% group_by(Disciplina,Mejora.de.Trabajos) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))
porcentajes_data$Disciplina <- factor(porcentajes_data$Disciplina,
                                      levels = c("FFL",
                                                 "TIC",
                                                 "Otras")
                                      )
porcentajes_data$Mejora.de.Trabajos <- factor(porcentajes_data$Mejora.de.Trabajos,
                                      levels = c("Lo he hecho","Me gustaría hacerlo","No me parece útil"))

ggplot(porcentajes_data, aes(x=Mejora.de.Trabajos, fill=Disciplina, y = Proporción)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso", x="Frecuencia", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/mejora-trabajos.png", width = 10, height = 6)

frecuencia_tabla <- table( frecuencias_data$Mejora.de.Trabajos, frecuencias_data$Disciplina)
chisq_frecuencia <- chisq.test(frecuencia_tabla)

genero_summary <-  frecuencias_data %>% group_by(Género,Mejora.de.Trabajos) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))
genero_summary$Género <- factor(genero_summary$Género,
                                      levels = c("Masculino",
                                                 "Femenino",
                                                 "Prefiero no decirlo")
                                      )
genero_summary$Mejora.de.Trabajos <- factor(genero_summary$Mejora.de.Trabajos,
                                      levels = c("Lo he hecho","Me gustaría hacerlo","No me parece útil" ))

ggplot(genero_summary, aes(x=Mejora.de.Trabajos, fill=Género, y = Proporción)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso por género", x="Frecuencia", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/mejora-trabajos-genero.png", width = 10, height = 6)
frecuencia_tabla_genero <- table( frecuencias_data$Mejora.de.Trabajos, frecuencias_data$Género)
chisq_frecuencia_genero <- chisq.test(frecuencia_tabla_genero)
