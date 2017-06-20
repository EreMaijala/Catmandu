package Catmandu::Fix::Builder::Update;

use Catmandu::Util qw(is_value is_array_ref is_hash_ref is_code_ref);
use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label) = @_;

    my $val = $self->value;

    if (is_code_ref($val)) {
        $val = $fixer->capture($val);
        "${var} = ${val}->(${var});";
    } elsif (is_value($val)) {
        $val = $fixer->emit_value($self->value);
        "${var} = ${val};";
    } elsif (is_array_ref($val) || is_hash_ref($val)) {
        $val = $fixer->capture($val);
        "${var} = ${val};";
    } else {
        "${var} = undef;";
    }
}

1;

