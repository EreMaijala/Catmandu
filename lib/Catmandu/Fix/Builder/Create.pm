package Catmandu::Fix::Builder::Create;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnstash', 'Catmandu::Fix::Builder::CanUpdate';

has path => (is => 'ro', required => 1);

sub emit_step {
    my ($self, $step, %ctx) = @_;

    if (my $val_var = $ctx{stash_val_var}) {
        my $var = $ctx{var};
        return "${var} = ${val_var};";
    }

    $step->emit(%ctx);
}

sub emit {
    my ($self, %ctx) = @_;

    my $fixer = $ctx{fixer};
    my $path  = $fixer->split_path($self->path);
    my $key   = pop @$path;
    
    my $is_unstash = $self->steps->[0] && $self->steps->[0]->isa('Catmandu::Fix::Builder::Unstash');

    my $perl = "";

    # handle the $builder->create('list.$append')->unstash case
    # TODO make it work with multiple steps
    # TODO check the path for $append/$prepend/*
    if ($is_unstash) {
        my $stash_var = $ctx{stash_var};
        my $stash_val_var = $ctx{stash_val_var} = $fixer->generate_var;
        $perl .= "while (\@{${stash_var}}) {" .
            $fixer->emit_declare_vars($stash_val_var, "shift(\@{$stash_var})");
    }

    $perl .= $fixer->emit_create_path(
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

    if ($is_unstash) {
        $perl .= "}";
    }

    $perl;
}

1;

