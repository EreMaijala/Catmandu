package Catmandu::Fix::Builder::Delete;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

sub emit {
    my ($self, $fixer, $label, $var, $container_var, $key) = @_;

    $fixer->emit_delete_key($container_var, $key);
}

1;
