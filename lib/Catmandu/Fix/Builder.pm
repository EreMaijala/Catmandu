package Catmandu::Fix::Builder;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanGet',
    'Catmandu::Fix::Builder::CanSet', 'Catmandu::Fix::Builder::CanCreate';

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    my $stash_var = $fixer->generate_var;
    $fixer->emit_declare_vars($stash_var, '[]')
        . $self->emit_steps(
        fixer     => $fixer,
        label     => $label,
        var       => $var // $fixer->var,
        stash_var => $stash_var,
        );
}

1;
