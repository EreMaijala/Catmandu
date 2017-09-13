package Catmandu::Fix::Builder::If;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanSet',
    'Catmandu::Fix::Builder::CanCreate',  'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnstash', 'Catmandu::Fix::Builder::CanApply',
    'Catmandu::Fix::Builder::CanUpdate',  'Catmandu::Fix::Builder::CanDelete',
    'Catmandu::Fix::Builder::CanIf';

has type => (is => 'ro');
has cb => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;

    return '' unless @{$self->steps};

    my $var = $ctx{var};
    my $fixer = $ctx{fixer};
    my $if;

    if ($self->type) {
        my $type = $self->type;
        $if = "is_${type}(${var})";
    } elsif ($self->cb) {
        my $if_var = $fixer->capture($self->cb);
        $if = "${if_var}->(${var})";
    }

    "if ($if) {" . $self->emit_steps(%ctx) . "}";
}

1;

