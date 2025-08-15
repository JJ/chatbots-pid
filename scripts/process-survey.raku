#!/usr/bin/env raku
use v6;
use Text::CSV;

# Define the columns we're interested in
my %columns-of-interest = (
    '¿Cuál es su campo de estudio/área de trabajo' => 'disciplina',
    'Lea y valore las siguientes afirmaciones sobre chatbots' => 'afirmaciones-sobre-chatbots',
    'Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles?' => 'usos-de-chatbots',
    '¿Con que frecuencia utiliza chatbots?' => 'frecuencia-de-uso',
    '¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa?' => 'chatbots-conocidos'
);

my $input-file = 'data-raw/encuesta.csv';
my $output-file = 'data/estudiantes.csv';

# Create CSV parser
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");


my @output-data;

for @data -> %row {
    my %output-row;
    for %columns-of-interest.kv -> $key, $value {
        %output-row{$value} = %row{$key};
    }
    @output-data.push: %output-row;
}


