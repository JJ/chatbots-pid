#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/encuesta.csv';
my $input-file-piloto = 'data-raw/estudiantes-piloto.csv';
my $output-file = 'data/actitudes.csv';
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

my %columns-of-interest = (
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots proporcionan respuestas confiables y precisas a mis preguntas académicas.]"=>"respuestas-confiables",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots pueden ofrecer explicaciones claras y comprensibles sobre temas complejos.]"=>"explicaciones-claras",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots me ayudan con mis tareas y proyectos.]"=>"ayudan",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots deben ser una parte integral de la experiencia educativa de un/a estudiante.]"=>"parte-integral",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots pueden ayudar a mejorar las habilidades de estudio y aprendizaje.]" => "mejorar-habilidades",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots en el ámbito universitario es ético.]"=>"ético",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots manejan correctamente los datos sensibles.]"=>"manejan-datos",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots proporcionan información sesgada.]"=>"información-segura",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots conduce a la dependencia tecnológica.]"=>"dependencia-tecnológica",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots no respetan la privacidad de los usuarios.]"=>"no-respetan-privacidad",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots conduce a una falta de pensamiento crítico.]"=>"no-pensamiento-crítico"
    );


my %columns-of-interest-piloto = (
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots proporcionan respuestas confiables y precisas a mis preguntas académicas.]"=>"respuestas-confiables",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots pueden ofrecer explicaciones claras y comprensibles sobre temas complejos.]"=>"explicaciones-claras",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots me ayudan con mis tareas y proyectos.]"=>"ayudan",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots deben ser una parte integral de la experiencia educativa de un/a estudiante.]"=>"parte-integral",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots pueden ayudar a mejorar las habilidades de estudio y aprendizaje.]" => "mejorar-habilidades",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots en el ámbito universitario es ético.]"=>"ético",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots manejan correctamente los datos sensibles.]"=>"manejan-datos",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots proporcionan información sesgada.]"=>"información-segura",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots tienen un problema de privacidad.]"=>"problema-privacidad",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots conduce a la dependencia tecnológica.]"=>"dependencia-tecnológica",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [Los chatbots no respetan la privacidad de los usuarios.]"=>"no-respetan-privacidad",
    "Lea y valore las siguientes afirmaciones sobre chatbots. [El uso de chatbots conduce a una falta de pensamiento crítico.]"=>"no-pensamiento-crítico"
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
    for %columns-of-interest-piloto.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

say @output-data;
csv( in => @output-data, out => $output-file, sep=> ";");


