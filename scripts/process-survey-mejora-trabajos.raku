#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/encuesta.csv';
my $output-file = 'data/mejora-trabajos.csv';
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

my %columns-of-interest = (
    "Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles? [Mejorar la calidad de mis trabajos (redacción de textos, programación, etc.)]" => "Mejora de Trabajos",
    "¿Con qué género se identifica?" => "Género"
    );

for @data -> %row {
    next if %row{"¿Cuál es su perfil?"} eq "Docente";
    my %translated = ( "Disciplina" => translate-disciplina(%row{"¿Cuál es su campo de estudio/área de trabajo?"}) );
    for %columns-of-interest.kv -> $key, $value {
        %translated{$value} = %row{$key};
    }
    @output-data.push: %translated;
}

csv( in => @output-data, out => $output-file, sep=> ";");


