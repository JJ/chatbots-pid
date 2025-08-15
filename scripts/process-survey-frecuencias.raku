#!/usr/bin/env raku
use v6;
use Text::CSV;

my $input-file = 'data-raw/encuesta.csv';
my $input-file-piloto = 'data-raw/estudiantes-piloto.csv';
my $output-file = 'data/frecuencias.csv';

# Create CSV parser
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

sub process-survey-row(%row, Bool $piloto) {
    my %output-row = ( "Frecuencia" => %row{"¿Con que frecuencia utiliza chatbots?"}, "Piloto" => $piloto );
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
    return %output-row;
}

for @data -> %row {
    @output-data.push: process-survey-row(%row, False);
}
for @data-piloto -> %row {
    @output-data.push: process-survey-row(%row, True);
}

csv( in => @output-data, out => $output-file, sep=> ";");


