package Catmandu::Fix::Builder::Delete;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

with 'Catmandu::Fix::Builder::Base';

sub emit {
    my ($self, %ctx) = @_;

    if ($ctx{key} // $ctx{index_var}) {
        $ctx{fixer}->emit_delete($ctx{up_var}, $ctx{key}, $ctx{index_var});
    }
    else {
        $ctx{fixer}->emit_clear_hash_ref($ctx{var});
    }
}

1;
