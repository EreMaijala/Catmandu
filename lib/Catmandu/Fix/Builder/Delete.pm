package Catmandu::Fix::Builder::Delete;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

sub emit {
    my ($self, $fixer, $label, $var, $up_var, $key, $index_var) = @_;

    if ($key // $index_var) {
        $fixer->emit_delete($up_var, $key, $index_var);
    } else {
        'Catmandu::NotImplemented->throw;';
    }
}

1;
