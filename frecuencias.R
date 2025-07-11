library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/frecuencias.csv", header = TRUE, sep = ";")

porcentajes_data <-  frecuencias_data %>% group_by(Disciplina,Frecuencia) %>%
  summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

# reorder the levels of 'Frecuencia' for better visualization first none, then Nunca, then Casi nunca, then A veces, then Casi Siempre, then Siempre
porcentajes_data$Frecuencia <- factor(porcentajes_data$Frecuencia,
                                      levels = c("", "Nunca", "Casi nunca", "A veces", "Casi siempre", "Siempre"))

ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
  geom_bar( stat="identity", position="dodge") +
  labs(title="Frecuencia de uso", x="Frecuencia", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/frecuencias.png", width = 10, height = 6)
