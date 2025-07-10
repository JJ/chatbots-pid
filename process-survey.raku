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
my $csv = Text::CSV.new(
    :binary,
    :sep_char(","),
    :quote_char("\""),
    :escape_char("\""),
    :strict(True)
);

# Open files
my $in = open($input-file, :r) or die "Cannot open $input-file: $!";
my $out = open($output-file, :w) or die "Cannot open $output-file: $!";

# Read header
my @headers = $csv.getline($in);
my %header-index = @headers.kv.map: { $^v => $^k };

# Find index of profile column
my $profile-index = %header-index{'Cual es su perfil'};

# Print header for output
$out.say: join(",",
    'Cual es su perfil',
    @columns-of-interest
);

# Process each row
while my $row = $csv.getline($in) {
    # Only process rows where profile is "Estudiante" (case-insensitive)
    if $row[$profile-index] ~~ m:i/estudiante/ {
        # Extract the values for our columns of interest
        my @values = (
            $row[$profile-index],
            @columns-of-interest.map: { $row[%header-index{$_}] }
        );
        
        # Print the filtered row
        $out.say: join(",", @values);
    }
}

# Close files
$in.close;
$out.close;

say "Processing complete. Results written to $output-file";
