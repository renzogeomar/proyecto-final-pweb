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
my $ruta = $q->param('ruta');

# Ruta al archivo de datos
my $data_file = "/var/www/html/pages/pages_data.txt";

# Codificar saltos de línea en el contenido
$contenido =~ s/\n/\\n/g;

# Actualizar el archivo de datos
if (-e $data_file) {
    open my $fh, '<', $data_file or die "No se puede abrir el archivo de datos: $!";
    my @lines = <$fh>;
    close $fh;

    open my $fh_out, '>', $data_file or die "No se puede abrir el archivo para escritura: $!";
    foreach my $line (@lines) {
        chomp $line;
        my ($titulo_file, $contenido_file, $ruta_file) = split /\|/, $line;
        
        if ($titulo eq $titulo_file) {
            # Reemplazar con los datos actualizados
            print $fh_out "$titulo|$contenido|$ruta\n";
        } else {
            print $fh_out "$line\n";
        }
    }
    close $fh_out;
}

# Actualizar el archivo HTML correspondiente
my $html_file = "/var/www/html/pages/$ruta";
open my $html_fh, '>', $html_file or die "No se puede crear el archivo HTML: $!";
print $html_fh "<html lang=\"es\"><head><title>$titulo</title></head><body>";
print $html_fh "<h1>$titulo</h1>";
print $html_fh "<p>$contenido</p>";  # Aquí los saltos de línea no son necesarios.
print $html_fh "</body></html>";
close $html_fh;

# Redirigir al listado
print $q->redirect('/cgi-bin/list.pl');