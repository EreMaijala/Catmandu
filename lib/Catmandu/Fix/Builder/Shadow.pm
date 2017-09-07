package Catmandu::Fix::Builder::Shadow;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has path => (is => 'ro', required => 1);

sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var) = ($ctx{fixer}, $ctx{var});
    my $path       = $fixer->split_path($self->path);
    my $key        = pop @$path;
    my $shadow_var = $fixer->_shadow_var;

    $fixer->emit_walk_path(
        $var, $path,
        sub {
            my ($var) = @_;
            $fixer->emit_get_key(
                $var, $key,
                sub {
                    my ($var) = @_;
                    $fixer->emit_create_path(
                        $shadow_var,
                        [@$path, $key],
                        sub {
                            my ($v) = @_;
                            "${v} = clone(${var});";
                        }
                    );
                }
            );
        }
    );
}

1;

