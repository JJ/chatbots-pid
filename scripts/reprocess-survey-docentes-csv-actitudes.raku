#!/usr/bin/env raku
use v6;
use lib 'lib';
use Text::CSV;
use Chatbot::Survey::SurveyProcessing;

my $input-file = 'data-raw/respuestas-docentes.csv';
my $input-file-piloto = 'data-raw/respuestas-docentes-piloto.csv';
my $output-file = 'data/chatbots-uso-docentes.csv';
my @data = csv( in=> $input-file, :encoding<utf8>, sep=> ";", headers => "auto");
my @data-piloto = csv( in=> $input-file-piloto, :encoding<utf8>, sep=> ";", headers => "auto");

my @output-data;

my %columns-of-interest = (
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [ChatGPT]" => "ChatGPT",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Copilot/Bing Chat]" =>"Copilot",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Gemini]" => "Gemini",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Claude]" => "Claude",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [NotebookLM]" => "NotebookLM",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [DeepSeek]" => "DeepSeek",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Perplexity]" => "Perplexity"
);

my %columns-of-interest-piloto = (
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [ChatGPT]" => "ChatGPT",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Copilot/Bing Chat]" =>"Copilot",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Gemini]" => "Gemini",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [Claude]" => "Claude",
    "¿Qué chatbots (programas que simulan una conversación humana para proporcionar información o realizar tareas) conoce y/o usa? [NotebookLM]" => "NotebookLM"
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


