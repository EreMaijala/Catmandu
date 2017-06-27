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
    my $key  = pop @$path;

    $fixer->emit_create_path(
        $var,
        $path,
        sub {
            my ($up_var) = @_;
            $fixer->emit_create_path(
                $up_var, [$key],
                sub {
                    my ($var, $index_var) = @_;
                    $self->emit_steps($fixer, $label, $var, $up_var, $key, $index_var);
                }
            );
        }
    );
}

1;

