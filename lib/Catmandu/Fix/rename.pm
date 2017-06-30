package Catmandu::Fix::rename;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Moo;
use Catmandu::Util qw(is_hash_ref is_array_ref);
use namespace::clean;
use Catmandu::Fix::Has;

has path    => (fix_arg => 1);
has search  => (fix_arg => 1);
has replace => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $substituter = $builder->substitution($self->search, $self->replace);
    my $renamer;

    $renamer = sub {
        my $data = $_[0];

        if (is_array_ref($data)) {
            $renamer->($_) for @$data;
        }
        elsif (is_hash_ref($data)) {
            for my $old (keys %$data) {
                my $new = $substituter->($old);
                my $val = $data->{$old};
                if ($new ne $old) {
                    delete $data->{$old};
                    $data->{$new} = $val;
                }
                $renamer->($val);
            }
        }
    };

    $builder->get($self->path)->apply($renamer);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::rename - rename fields with a regex

=head1 SYNOPSIS

   # dotted => {'ns.foo' => 'val', list => {'ns.bar' => 'val'}}
   rename(dotted, '\.', '-')
   # dotted => {'ns-foo' => 'val', list => {'ns-bar' => 'val'}}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
