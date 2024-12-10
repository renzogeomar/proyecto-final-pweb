#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';

my $q = CGI->new();
print $q->header('text/html; charset=UTF-8');
print "<html lang=\"es\"><head><title>Listado de Páginas</title><link rel=\"stylesheet\" href=\"../css/style.css\">";

my $data_file = "/var/www/html/pages/pages_data.txt";
print "<div class='interfas'>";  # Clase cambiada a "interfas"

if (-e $data_file) {
    print "<h1>Listado de páginas</h1>";
    open my $fh, '<', $data_file or die "No se puede abrir el archivo de datos: $!";

    while (my $line = <$fh>) {
        chomp $line;
        my ($titulo, $contenido, $ruta) = split /\|/, $line;

        # Enlace al script view.pl con el nombre de la página como parámetro
        print "<a href='/cgi-bin/view.pl?titulo=$titulo'>$titulo</a><br>";

        # Agrupar los botones de eliminar y editar dentro de un div 'boton'
        print "<div class='boton'>";
        print "<form action='/cgi-bin/delete.pl' method='get' style='display:inline;'>
                  <input type='hidden' name='titulo' value='$titulo'>
                  <button type='submit' style='color:red;'>[X] Eliminar</button>
              </form> ";
        print "<form action='/cgi-bin/edit.pl' method='get' style='display:inline;'>
                  <input type='hidden' name='titulo' value='$titulo'>
                  <button type='submit' style='color:blue;'>[E] Editar</button>
              </form>";
        print "</div><br><br>";
    }
    close $fh;
} 
else {
    print "<h1>No hay páginas creadas.</h1>";
}

print "<div class='boton'>";
print "<form action='/new.html' method='get'>
            <button type='submit'>Agregar</button>
          </form>";
print "</div>";

print "<div class='botonInicio'>";
print "<form action='/index.html' method='get'>";
print "<button type='submit'>Inicio</button>";
print "</form>";
print "</div>";

print "</div>";
print "</body></html>";