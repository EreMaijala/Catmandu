package Catmandu::Fix::Builder::Unless;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has cb => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $cb_var = $fixer->capture($self->cb);

    "unless (${cb_var}->(${var})) {" .
        $self->emit_steps($fixer, $label, $var) .
    "}";
}

1;

