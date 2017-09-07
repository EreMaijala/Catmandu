package Catmandu::Fix::Builder::Unshadow;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var) = ($ctx{fixer}, $ctx{var});
    my $shadow_var = $fixer->_shadow_var;

    "if (%{${var}}) {"
    . "Catmandu::NotImplemented->throw;"
    . "} else {"
    . $fixer->emit_foreach_key(
    $shadow_var,
    sub {
        my $v = $_[0];
        "${var}->{${v}} = ${shadow_var}->{${v}};";
    }
    )
    . "undef %{${shadow_var}};"
    . "}";
}

1;

