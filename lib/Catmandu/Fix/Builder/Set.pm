package Catmandu::Fix::Builder::Set;

use Catmandu::Util qw(is_value is_code_ref);
use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $val = $self->value;

    if (is_value($val)) {
        $val = $fixer->emit_value($self->value);
        "${var} = ${val};";
    } elsif (is_code_ref($val)) {
        $val = $fixer->capture($val);
        "${var} = ${val}->(${var});";
    } elsif (!defined $val) {
        "${var} = undef;";
    }
}

1;

