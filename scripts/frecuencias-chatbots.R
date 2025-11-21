library(ggplot2)
library(dplyr)

frecuencias_data <- read.csv("data/chatbots-uso-docentes.csv", header = TRUE, na.strings="", sep = ";")
frecuencias_data$Disciplina <- ifelse( frecuencias_data$Disciplina=="TIC", "TIC", "Otras")

columnas <- strsplit("ChatGPT;Claude;Copilot;DeepSeek;Gemini;NotebookLM;Perplexity", ";")

for ( i in columnas[[1]] ) {
  frecuencias_uso_data  <-  data.frame(Disciplina = frecuencias_data$Disciplina,
                                       frecuencias_data[i])

  porcentajes_data <-  frecuencias_uso_data %>% group_by(Disciplina,.data[[i]]) %>%
    summarise(Número = n()) %>%
  mutate(Proporción = Número / sum(Número))

  porcentajes_data$Frecuencia <- factor(porcentajes_data[[i]],
                                      levels = c("No lo conozco",
                                                 "Lo conozco, pero no lo he usado",
                                                 "Lo uso en el contexto universitario",
                                                 "Lo uso tanto en el conexto universitario como para otras tareas",
                                                 "Lo uso para otras tareas" )
                                      )
  porcentajes_data$Disciplina <- factor(porcentajes_data$Disciplina,
                                        levels = c("TIC",
                                                   "Otras")
                                        )

  porcentajes_data <- porcentajes_data %>%
    filter(!is.na(Frecuencia))
  ggplot(porcentajes_data, aes(x=Frecuencia, fill=Disciplina, y = Proporción)) +
    geom_bar( stat="identity", position="dodge") +
    labs(title=paste0("Actitud docentes sobre ",i), x="Frecuencia", y="Proporción") +
    theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste0("figures/actitudes-docentes",i, ".png"), width = 10, height = 6)

  frecuencia_tabla <- table( unname(unlist(frecuencias_data[i])), frecuencias_data$Disciplina)
  chisq_frecuencia <- chisq.test(frecuencia_tabla)
  if ( chisq_frecuencia$p.value < 0.05 ) {
    cat("✅ La prueba de chi-cuadrado indica que hay una diferencia significativa en la actitud 📈", i, "📈 con p-value ", chisq_frecuencia$p.value,"\n")
  }
}

frecuencias_data$ChatGPT %>%
  table() %>%
  as.data.frame() %>%
  mutate(Proporción = Freq / sum(Freq)) -> ChatGPT_data
colnames(ChatGPT_data) <- c("Pregunta","Número","Proporción")

ChatGPT_data$Pregunta <- factor(ChatGPT_data$Pregunta,
                              levels = c("No lo conozco",
                                         "Lo conozco, pero no lo he usado",
                                         "Lo uso en el contexto universitario",
                                         "Lo uso tanto en el conexto universitario como para otras tareas",
                                         "Lo uso para otras tareas" )
                              )
# add Proporción number to bar
ggplot(ChatGPT_data, aes(x=Pregunta, y=Proporción)) +
  geom_bar(stat="identity", fill="#0073C2FF") +
  geom_text(aes(label=sprintf("%.2f", Proporción)), size=5) +
  labs(title="Frecuencia de uso de ChatGPT", x="Frecuencia", y="Proporción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("figures/frecuencias-uso-chatgpt.png", width = 10, height = 6)
