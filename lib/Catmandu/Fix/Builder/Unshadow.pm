package Catmandu::Fix::Builder::Unshadow;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var, $stash_var) = ($ctx{fixer}, $ctx{var}, $ctx{stash_var});
    my $name       = $fixer->emit_string('_shadow');
    my $shadow_var = "${stash_var}->{${name}}";

    "if (is_hash_ref(${shadow_var})) {"
        . "if (%{${var}}) {"
        . "Catmandu::NotImplemented->throw;"
        . "} else {"
        . $fixer->emit_foreach_key(
        $shadow_var,
        sub {
            my $v = $_[0];
            "${var}->{${v}} = ${shadow_var}->{${v}};";
        }
        )
        . "}"
        . $fixer->emit_clear_hash_ref($shadow_var) . "}";
}

1;

