package Catmandu::Fix::Builder::If;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has condition => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $if_var = $fixer->capture($self->condition);

    "if (${if_var}->(${var})) {" .
        $self->emit_steps($fixer, $label, $var) .
    "}";
}

1;

