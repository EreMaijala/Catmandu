package Catmandu::Fix::Builder::Create;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has path => (is => 'ro', required => 1);

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $path = $fixer->split_path($self->path);

    $fixer->emit_create_path(
        $fixer->var,
        $path,
        sub {
            my $var = $_[0];
            $self->emit_steps($fixer, $label, $var);
        }
    );

}

1;

