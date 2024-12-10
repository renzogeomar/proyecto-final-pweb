#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';

# Crear objeto CGI
my $q = CGI->new();
print $q->header('text/html; charset=UTF-8');
print "<html lang=\"es\"><head><title>Editar Página</title><link rel=\"stylesheet\" href=\"../css/style.css\"></head><body>";

# Obtener el nombre de la página a editar
my $titulo = $q->param('titulo');

# Ruta al archivo de datos
my $data_file = "/var/www/html/pages/pages_data.txt";
my $found = 0;
my ($contenido, $ruta);

# Verificar si el archivo de datos existe
if (-e $data_file) {
    open my $fh, '<', $data_file or die "No se puede abrir el archivo de datos: $!";

    while (my $line = <$fh>) {
        chomp $line;
        my ($titulo_file, $contenido_file, $ruta_file) = split /\|/, $line;

        # Buscar la página por su título
        if ($titulo eq $titulo_file) {
            # Decodificar saltos de línea
            $contenido = $contenido_file;
            $contenido =~ s/\\n/\n/g;  # Convertir el marcador especial en saltos de línea reales
            $ruta = $ruta_file;
            $found = 1;
            last;
        }
    }
    close $fh;
}

print "<div class='interfas'>";

if ($found) {
    # Mostrar el nombre de la página y un formulario para editar el contenido
    print "<h1>Editar: $titulo</h1>";
    print "<form method='POST' action='/cgi-bin/save.pl'>";
    print "<input type='hidden' name='titulo' value='$titulo'>";
    print "<input type='hidden' name='ruta' value='$ruta'>";
    print "<textarea name='contenido' rows='10' cols='50'>$contenido</textarea><br><br>";

    print "<div class='boton'>";
    print "<button type='submit'>Guardar cambios</button>";
    print "</div>";

    print "</form>";
} else {
    print "<h1>Página no encontrada.</h1>";
}

print "<div class='botonInicio'>";
print "<form action='/cgi-bin/list.pl' method='get'>";
print "<button type='submit'>Regresar</button>";
print "</form>";
print "</div>";

print "</div>";
print "</body></html>";