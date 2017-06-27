package Catmandu::Fix::Builder::Set;

use Catmandu::Util qw(is_value is_array_ref is_hash_ref is_code_ref);
use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

with 'Catmandu::Fix::Builder::Base';

has path => (is => 'ro', required => 1);
has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $path = $fixer->split_path($self->path);
    my $key  = pop @$path;
    my $val  = $self->value;
    my $perl_val;

    if (is_code_ref($val)) {
        my $val_var = $fixer->capture($val);
        $perl_val = "${val_var}->();";
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

    $fixer->emit_walk_path(
        $var, $path,
        sub {
            my $var = $_[0];
            $fixer->emit_set_key($var, $key, $perl_val);
        }
    );
}

1;
