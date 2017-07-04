package Catmandu::Fix::Builder::If;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanSet',
    'Catmandu::Fix::Builder::CanCreate',  'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnstash', 'Catmandu::Fix::Builder::CanApply',
    'Catmandu::Fix::Builder::CanUpdate',  'Catmandu::Fix::Builder::CanDelete',  'Catmandu::Fix::Builder::CanIf';

has condition => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;

    my $var = $ctx{var};
    my $if_var = $ctx{fixer}->capture($self->condition);

    "if (${if_var}->(${var})) {"
        . $self->emit_steps(%ctx) . "}";
}

1;

