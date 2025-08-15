use v6.d;

#| Module for processing survey data
unit module Chatbot::Survey::SurveyProcessing;

#| Process a survey row and return a hash with frequency and discipline information
sub process-survey-row(%row, Bool $piloto) is export {
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
