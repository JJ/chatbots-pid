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

ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso", x="Frecuencia", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/frecuencias.png", width = 10, height = 6)

frecuencia_tabla <- table( frecuencias_data$Frecuencia, frecuencias_data$Disciplina)
chisq_frecuencia <- chisq.test(frecuencia_tabla)
