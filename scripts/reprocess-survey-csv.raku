#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/encuesta.csv';
my $input-file-piloto = 'data-raw/estudiantes-piloto.csv';
my $output-file = 'data/frecuencias-uso.csv';
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

my %columns-of-interest = (
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Preparar ejercicios o ejemplos (p. ej. para practicar para un examen)]" => "preparar-examen",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Generar material de estudio complementario]" => "generar-material",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Mejorar la corrección preliminar de ejercicios y dar retroalimentación (feedback)]" => "feedback",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Ayudar en la resolución de ejercicios como un/a profesor/a particular]" => "profesor-particular",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Asistencia en procedimientos legales, becas y ayudas]" => "burocracia",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Comunicación entre profesorado y alumnado]" => "comunicacion-profesorado",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas administrativas relacionadas con una asignatura]" => "administrativas",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Resumir material de estudio (a partir de vídeos, de texto, etc.)]" => "resumen",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas sobre el temario]" => "preguntas-temario",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Recordar fechas importantes (deadlines, entregas de trabajos...)]" => "calendario",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Tareas de traducción]" => "traduccion",
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Mejorar la calidad de mis trabajos (redacción de textos, programación, etc.)]" => "mejorar-calidad"
);

for @data -> %row {
    next if %row{"¿Cuál es su perfil?"} eq "Docente";
    my %translated = ( "Disciplina" => translate-disciplina(%row{"¿Cuál es su campo de estudio/área de trabajo?"}) );
    for %columns-of-interest.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

for @data-piloto -> %row {
    next if %row{"¿Cuál es su perfil?"} eq "Docente";
    my %translated = ( "Disciplina" => translate-disciplina(%row{"¿Cuál es su campo de estudio/área de trabajo?"}) );
    for %columns-of-interest.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

csv( in => @output-data, out => $output-file, sep=> ";");


