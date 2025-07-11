#!/usr/bin/env raku
use v6;
use Text::CSV;

my $input-file = 'data-raw/encuesta.csv';
my $output-file = 'data/frecuencias.csv';

# Create CSV parser
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");


my @output-data;

for @data -> %row {
    my %output-row = ( "Frecuencia" => %row{"¿Con que frecuencia utiliza chatbots?"} );
    my $disciplina;
    my $esta-disciplina = %row{"¿Cuál es su campo de estudio/área de trabajo?"};

    given $esta-disciplina {
        when /Ingenierías|Computación|Informática/ {
            $disciplina = "TIC";
        }
        when /Traducción|Filología/ {
            $disciplina = "Lengua";
        }
        default {
            $disciplina = "Otro";
        }
    }
    %output-row{"Disciplina"} = $disciplina;

    @output-data.push: %output-row;
}

csv( in => @output-data, out => $output-file, sep=> ";");


