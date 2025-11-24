library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/chatbots-en.csv", header = TRUE, na.strings="", sep = ";")

columnas <- strsplit("ChatGPT;Claude;Copilot;DeepSeek;Gemini;NotebookLM;Perplexity", ";")
resultados_uso <- data.frame( chatbot=character(),
                              frecuencia=character(),
                              porcentaje = numeric() );

for ( i in columnas[[1]] ) {
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  porcentajes_data <-  frecuencias_uso_data %>% group_by(.data[[i]]) %>% summarise(Número = n()) %>%
    mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("No lo conozco",
                                                 "Lo conozco pero no lo he usado",
                                                 "Lo uso en el conexto universitario",
                                                 "Lo uso tanto en el conexto universitario como para otras tareas",
                                                 "Lo uso para otras tareas" )
                                      )
  porcentajes_data <- porcentajes_data %>%
    filter(!is.na(Frecuencia))

  for (j in levels(porcentajes_data$Frecuencia) ) {
    resultados_uso <- rbind( resultados_uso,
                             data.frame( chatbot = i,
                                         frecuencia = j,
                                         porcentaje = sum( porcentajes_data$Proporción[porcentajes_data$Frecuencia == j] )
                             )
    )
  }

}

resultados_uso$chatbot <- factor(resultados_uso$chatbot,
                             levels = resultados_uso %>%
                               filter(frecuencia == "Lo uso tanto en el conexto universitario como para otras tareas") %>%
                               arrange(porcentaje) %>% pull(chatbot)
)
ggplot(resultados_uso, aes(x=chatbot, fill=frecuencia, y = porcentaje)) +
    geom_bar( stat="identity", position="dodge") +
    labs(x="Frequency", y="Proportion") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  # change legend title to "frequency"
  labs(fill="Frequency")

ggsave("figures/frecuencias-uso-chatbots.png", width = 10, height = 6)
