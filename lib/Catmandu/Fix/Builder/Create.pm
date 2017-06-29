package Catmandu::Fix::Builder::Create;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnStash', 'Catmandu::Fix::Builder::CanUpdate';

has path => (is => 'ro', required => 1);

sub emit {
    my ($self, %ctx) = @_;

    my $fixer = $ctx{fixer};
    my $path  = $fixer->split_path($self->path);
    my $key   = pop @$path;

    $fixer->emit_create_path(
        $ctx{var},
        $path,
        sub {
            my ($up_var) = @_;
            $fixer->emit_create_path(
                $up_var,
                [$key],
                sub {
                    my ($var, $index_var) = @_;
                    $self->emit_steps(
                        %ctx,
                        var       => $var,
                        up_var    => $up_var,
                        key       => $key,
                        index_var => $index_var
                    );
                }
            );
        }
    );
}

1;

