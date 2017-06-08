package Catmandu::Fix::Builder::At;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has path => (is => 'ro', required => 1);
has cb => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $cb_var;
    if ($self->cb) {
        $cb_var = $fixer->capture($self->cb);
    }

    my $segments = $fixer->split_path($self->path);
    my $key = pop @$segments;

    $fixer->emit_walk_path(
        $var,
        $segments,
        sub {
            my $container_var = $_[0];
            $fixer->emit_get_key(
                $container_var, $key,
                sub {
                    my $var = $_[0];
                    my $perl = "";
                    if ($cb_var) {
                        $perl .= "${cb_var}->(${var});";
                    }
                    $perl . $self->emit_steps($fixer, $label, $var, $container_var, $key);
                }
            );
        }
    );
}

1;
