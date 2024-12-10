#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use File::Basename;

# Crear objeto CGI
my $q = CGI->new();
print $q->header('text/html; charset=UTF-8');
print "<html lang=\"es\"><head><title>Eliminar Página</title><link rel=\"stylesheet\" href=\"../css/style.css\"></head><body>";

print "<div class='interfas'>";

# Obtener el título de la página a eliminar
my $titulo = $q->param('titulo');

if ($titulo) {
    # Crear un nombre de archivo seguro
    my $filename = $titulo;
    $filename =~ s/[^a-zA-Z0-9_-]/_/g; # Reemplazar caracteres no válidos con "_"
    $filename .= ".html";

    # Ruta al archivo HTML y al archivo de datos
    my $file_path = "/var/www/html/pages/$filename";
    my $data_file = "/var/www/html/pages/pages_data.txt";
    
    # Eliminar el archivo HTML
    if (-e $file_path) {
        unlink $file_path or die "No se pudo eliminar el archivo HTML: $!";
        print "<h1>Página HTML eliminada correctamente</h1>";
    } else {
        #print "<h1>Error: No se encontró el archivo HTML.</h1>";
    }

    # Eliminar la entrada en el archivo de datos
    open my $data_fh, '<', $data_file or die "No se pudo abrir el archivo de datos: $!";
    my @lines = <$data_fh>;
    close $data_fh;

    open my $data_fh_write, '>', $data_file or die "No se pudo abrir el archivo de datos para escritura: $!";
    foreach my $line (@lines) {
        my ($file_titulo) = split /\|/, $line;
        if ($file_titulo ne $titulo) {
            print $data_fh_write $line;
        }
    }
    close $data_fh_write;

    print "<h1>Entrada de la página eliminada de la lista.</h1>";

    # Botón para regresar al listado dentro del div 'boton'
    print "<div class='boton'>";
    print "<form action='/cgi-bin/list.pl' method='get'>";
    print "<button type='submit'>Regresar al listado</button>";
    print "</form>";
    print "</div>";

} else {
    print "<h1>Error: No se especificó el título de la página.</h1>";
}

# Cerrar el contenedor 'interfas'
print "</div>";

print "</body></html>";