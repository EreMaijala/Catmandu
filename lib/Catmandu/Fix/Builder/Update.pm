package Catmandu::Fix::Builder::Update;

use Catmandu::Util qw(is_value is_array_ref is_hash_ref is_code_ref);
use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;

extends 'Catmandu::Fix::Builder';

has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $val = $self->value;

    if (is_code_ref($val)) {
        my $val_var = $fixer->capture($val);
        "${var} = ${val_var}->(${var});";
    } elsif (is_value($val)) {
        $val = $fixer->emit_value($self->value);
        "${var} = ${val};";
    } elsif (is_array_ref($val) || is_hash_ref($val)) {
        my $val_var = $fixer->capture($val);
        "${var} = ${val_var};";
    } else {
        "${var} = undef;";
    }
}

1;

