package Catmandu::Fix::Builder::Update;

use Catmandu::Sane;

our $VERSION = '1.06';

use Catmandu::Util qw(is_value is_array_ref is_hash_ref is_code_ref);
use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has value => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;

    my $fixer   = $ctx{fixer};
    my $var     = $ctx{var};
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

    my $perl = $fixer->emit_declare_vars($tmp_var, $perl_val) . "if ("
        . $self->emit_is_cancel_and_delete($tmp_var) . ") {";
    if ($ctx{key} // $ctx{index_var}) {
        $perl
            .= $fixer->emit_delete($ctx{up_var}, $ctx{key}, $ctx{index_var});
    }
    else {
        $perl .= 'Catmandu::NotImplemented->throw;';
    }
    $perl
        . "} elsif (!"
        . $self->emit_is_cancel($tmp_var) . ") {"
        . "${var} = ${tmp_var};" . "}";
}

1;

