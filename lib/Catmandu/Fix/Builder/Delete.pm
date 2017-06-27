package Catmandu::Fix::Builder::Delete;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has path => (is => 'ro', required => 1);

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $path = $fixer->split_path($self->path);
    my $key  = pop @$path;

    $fixer->emit_walk_path(
        $var, $path,
        sub {
            my $var = $_[0];
            $fixer->emit_delete_key($var, $key);
        }
    );
}

1;
