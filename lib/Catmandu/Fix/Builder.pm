package Catmandu::Fix::Builder;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanGet',
    'Catmandu::Fix::Builder::CanSet',    'Catmandu::Fix::Builder::CanCreate',
    'Catmandu::Fix::Builder::CanApply',  'Catmandu::Fix::Builder::CanUpdate',
    'Catmandu::Fix::Builder::CanIf',     'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanDelete', 'Catmandu::Fix::Builder::CanShadow',
    'Catmandu::Fix::Builder::CanUnshadow';

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $self->emit_steps(
        fixer     => $fixer,
        label     => $label,
        var       => $var // $fixer->var,
    );
}

1;
