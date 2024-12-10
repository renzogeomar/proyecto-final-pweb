#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use utf8;
use DBI;
# Configuración de conexión a la base de datos
my $dsn = "DBI:mysql:database=informacion;host=localhost";
my $db_user = "tu_usuario";       # Usuario de la base de datos
my $db_password = "tu_contraseña"; # Contraseña del usuario
# Crear el objeto CGI
my $q = CGI->new();

# Encabezado XML
print $q->header('text/xml; charset=UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Recuperar los parámetros de entrada
my $user = $q->param('root');
my $password = $q->param('200622Re@');
# Variables para almacenar la respuesta
my ($owner, $firstName, $lastName) = ("", "", "");

# Verificar si se proporcionaron todos los parámetros
if (defined $user && defined $password) {
    # Conectar a la base de datos
    my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, AutoCommit => 1 });
    
    if ($dbh) {
        # Consulta SQL para verificar las credenciales
        my $sql = "SELECT userName, firstName, lastName FROM informacion WHERE userName = ? AND password = ?";
        my $sth = $dbh->prepare($sql);
        $sth->execute($user, $password);

        # Recuperar los resultados si hay coincidencia
        if (my @row = $sth->fetchrow_array) {
            ($owner, $firstName, $lastName) = @row;
        }
        $sth->finish;
        $dbh->disconnect;
    }
}

# Generar la salida XML
print "<user>\n";
print "  <owner>$owner</owner>\n";
print "  <firstName>$firstName</firstName>\n";
print "  <lastName>$lastName</lastName>\n";
print "</user>\n";
