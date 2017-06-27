package Catmandu::Fix::Builder::Update;

use Catmandu::Sane;

our $VERSION = '1.06';

use Catmandu::Util qw(is_value is_array_ref is_hash_ref is_code_ref);
use Moo;
use namespace::clean;

extends 'Catmandu::Fix::Builder';

has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var, $up_var, $key, $index_var) = @_;

    my $val     = $self->value;
    my $tmp_var = $fixer->generate_var;

    my $perl_val;
    if (is_code_ref($val)) {
        my $val_var = $fixer->capture($val);
        $perl_val = "${val_var}->(${var})";
    }
    elsif (is_value($val)) {
        $perl_val = $fixer->emit_value($val);
    }
    elsif (is_array_ref($val) || is_hash_ref($val)) {
        $perl_val = $fixer->capture($val);
    }
    else {
        $perl_val = "undef";
    }

    $fixer->emit_declare_vars($tmp_var, $perl_val) . "if ("
        . $self->emit_is_cancel_and_delete($tmp_var) . ") {"
        . $fixer->emit_delete($up_var, $key, $index_var)
        . "} elsif (!"
        . $self->emit_is_cancel($tmp_var) . ") {"
        . "${var} = ${tmp_var};" . "}";
}

1;

