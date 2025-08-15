#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/encuesta.csv';
my $input-file-piloto = 'data-raw/estudiantes-piloto.csv';
my $output-file = 'data/frecuencias.csv';

# Create CSV parser
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

for @data -> %row {
    @output-data.push: process-survey-row(%row, False);
}
for @data-piloto -> %row {
    @output-data.push: process-survey-row(%row, True);
}

csv( in => @output-data, out => $output-file, sep=> ";");


