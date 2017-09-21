package Catmandu::Fix::Builder::If;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Catmandu::Util qw(is_string is_code_ref);
use Moo;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanSet',
    'Catmandu::Fix::Builder::CanCreate',  'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnstash', 'Catmandu::Fix::Builder::CanApply',
    'Catmandu::Fix::Builder::CanUpdate',  'Catmandu::Fix::Builder::CanDelete',
    'Catmandu::Fix::Builder::CanIf';

has type      => (is => 'ro');
has condition => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;

    return '' unless @{$self->steps};

    my $condition = $self->condition;
    my $var       = $ctx{var};
    my $fixer     = $ctx{fixer};
    my $if;

    if (is_string($condition)) {
        $if = "${condition}(${var})";
    }
    elsif (is_code_ref($condition)) {
        my $if_var = $fixer->capture($condition);
        $if = "${if_var}->(${var})";
    }

    "if ($if) {" . $self->emit_steps(%ctx) . "}";
}

1;

