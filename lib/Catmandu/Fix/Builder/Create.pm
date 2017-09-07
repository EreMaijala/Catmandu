package Catmandu::Fix::Builder::Create;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanStash',
    'Catmandu::Fix::Builder::CanUnstash', 'Catmandu::Fix::Builder::CanApply',
    'Catmandu::Fix::Builder::CanUpdate',  'Catmandu::Fix::Builder::CanIf';

has path => (is => 'ro', required => 1);

sub emit_step {
    my ($self, $step, %ctx) = @_;

    my $perl = $step->emit(%ctx);

    # handle the $builder->create('list.$append')->unstash case
    # TODO shouldn't do this if cb
    if ($step->isa('Catmandu::Fix::Builder::Unstash')) {
        my $var     = $ctx{var};
        my $val_var = $ctx{stash_val_var};
        $perl
            = "if (defined(${val_var})) { ${var} = ${val_var} } else { ${perl}; ${val_var} = ${var} }";
    }

    $perl;
}

sub emit {
    my ($self, %ctx) = @_;

    my $fixer = $ctx{fixer};
    my $path  = $fixer->split_path($self->path);
    my $key   = pop @$path;

    my $is_unstash = $self->steps->[0]
        && $self->steps->[0]->isa('Catmandu::Fix::Builder::Unstash');

    # handle the $builder->create('list.$append')->unstash case
    # TODO make it work with multiple steps
    # TODO check the path for $append/$prepend/*
    my $stash_val_var;
    if ($is_unstash) {
        $stash_val_var = $ctx{stash_val_var} = $fixer->generate_var;
    }

    my $perl = $fixer->emit_create_path(
        $ctx{var},
        $path,
        sub {
            my ($up_var) = @_;

            # handle the empty path
            if (!defined $key) {
                return $self->emit_steps(%ctx);
            }

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
        my $stash_var = $fixer->_stash_var;
        my $stash_key = $fixer->emit_string($self->steps->[0]->names->[0]);
        $perl
            = "while (\@{${stash_var}->{${stash_key}} ||= []}) {"
            . $fixer->emit_declare_vars($stash_val_var)
            . $perl . "}";
    }

    $perl;
}

1;

