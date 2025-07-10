#!/usr/bin/env raku
use v6;
use Text::CSV;

# Define the columns we're interested in
my @columns-of-interest = (
    '¿Cuál es su campo de estudio/área de trabajo?',
    'Lea y valore las siguientes afirmaciones sobre chatbots',
    'Relacionado con el aprendizaje en el contexto universitario, ¿cuáles de la siguientes opciones de uso de chatbots le parecen útiles?',
    '¿Con que frecuencia utiliza chatbots?',
    '¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa?'
);

# Open input and output files
my $input-file = 'data-raw/encuesta.csv';
my $output-file = 'data/estudiantes.csv';

# Create CSV parser
my @data = csv( in=> $input-file, :sep(";"), :headers);
say @data;
