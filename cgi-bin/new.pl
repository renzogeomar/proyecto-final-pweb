#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';

# Crear objeto CGI
my $q = CGI->new();

# Obtener datos del formulario
my $titulo = $q->param('titulo');
my $contenido = $q->param('contenido');

# Validar que los campos no estén vacíos
if (!$titulo || !$contenido) {
    print $q->header('text/html; charset=UTF-8');
    print "<html lang=\"es\"><head><title>Error</title><link rel=\"stylesheet\" href=\"style.css\"></head><body>";
    print "<h1>Error: Título o contenido vacío.</h1>";
    print "<a href='/new.html'>Regresar</a>";
    print "</body></html>";
    exit;
}

# Ruta al archivo de datos
my $data_file = "/var/www/html/pages/pages_data.txt";

# Reemplazar saltos de línea en el contenido por un marcador (e.g., "\\n")
$contenido =~ s/\n/\\n/g;

# Guardar los datos en el archivo
open my $fh, '>>', $data_file or die "No se puede abrir el archivo: $!";
print $fh "$titulo|$contenido|$titulo.html\n";
close $fh;

# Crear la página HTML correspondiente
my $html_file = "/var/www/html/pages/$titulo.html";
open my $html_fh, '>', $html_file or die "No se puede crear el archivo HTML: $!";
print $html_fh "<html lang=\"es\"><head><title>$titulo</title></head><body>";
print $html_fh "<h1>$titulo</h1>";
print $html_fh "<p>$contenido</p>"; # Aquí todavía estará con los \n, pero se corregirá al leer.
print $html_fh "</body></html>";
close $html_fh;

# Redirigir al listado
print $q->redirect('/cgi-bin/list.pl');