use v6.d;

#| Module for processing survey data
unit module Chatbot::Survey::SurveyProcessing;

#| Translate disciplina
sub translate-disciplina($disciplina) is export {
    given $disciplina {
        when /Ingenierías|Computación|Informática/ {
            return "TIC";
        }
        when /Traducción|Filología/ {
            return "Lengua";
        }
        default {
            return "Otro";
        }
    }
}

#| Process a survey row and return a hash with frequency and discipline information
sub process-survey-row(%row, Bool $piloto) is export {
    my %output-row = ( "Frecuencia" => %row{"¿Con que frecuencia utiliza chatbots?"}, "Piloto" => $piloto );
    %output-row{"Disciplina"} = translate-disciplina(%row{"¿Cuál es su campo de estudio/área de trabajo?"});
    return %output-row;
}
