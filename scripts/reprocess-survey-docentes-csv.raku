#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/respuestas-docentes.csv';
my $input-file-piloto = 'data-raw/respuestas-docentes-piloto.csv';
my $output-file = 'data/frecuencias-uso-docentes.csv';
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

my %columns-of-interest = (
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Preparar ejercicios o ejemplos]"  => "preparar-examen",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Generar material didáctico complementario]" => "generar-material",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Mejorar la corrección preliminar de ejercicios y dar retroalimentación (feedback)]" => "feedback",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Ayudar en la resolución de ejercicios como un/a tutor/a]" => "profesor-particular",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Asistencia en procedimientos legales, becas y ayudas]" => "burocracia",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Comunicación entre el profesorado y el alumnado]" => "comunicacion-profesorado",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas administrativas]" => "administrativas",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Resumir material didáctico (a partir de vídeos, de texto, etc.)]" => "resumen",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas sobre el temario]" => "preguntas-temario",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Recordar fechas importantes (deadlines, entregas de trabajos...)]" => "calendario",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Tareas de traducción]" => "traduccion",
);

my %columns-of-interest-piloto = (
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Preparar ejercicios o ejemplos]"  => "preparar-examen",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Generar material didáctico complementario]" => "generar-material",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Mejorar la corrección preliminar de ejercicios y dar retroalimentación (feedback)]" => "feedback",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Ayudar en la resolución de ejercicios como un/a tutor/a]" => "profesor-particular",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Asistencia en procedimientos legales, becas y ayudas]" => "burocracia",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Comunicación entre el profesorado y el alumnado]" => "comunicacion-profesorado",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas administrativas]" => "administrativas",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Resumir material didáctico (a partir de vídeos, de texto, etc.)]" => "resumen",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Responder a preguntas sobre el temario]" => "preguntas-temario",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Recordar fechas importantes (deadlines, entregas de trabajos...)]" => "calendario",
    "Relacionado con la docencia en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Tareas de traducción]" => "traduccion",
);

for @data -> %row {
    next if %row{"¿Qué medios de comunicación usa en el contexto universitario?"} eq "";
    my %translated = ( "Disciplina" => translate-disciplina-docentes(%row{"¿Cuál es su campo de estudio/área de trabajo?"}) );
    for %columns-of-interest.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

for @data-piloto -> %row {
    next if %row{"¿Cuál es su perfil?"} ne "Docente";
    my %translated = ( "Disciplina" => translate-disciplina-docentes(%row{"¿Cuál es su campo de estudio/área de trabajo?"}) );
    for %columns-of-interest-piloto.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

csv( in => @output-data, out => $output-file, sep=> ";");


