package Catmandu::Fix::compact;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Catmandu::Util qw(is_array_ref);
use Moo;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_array_ref($val);
            [grep defined, @$val];
        }
    );
}

=head1 NAME

Catmandu::Fix::compact - remove undefined values from an array

=head1 SYNOPSIS

   # list => [undef,"hello",undef,"world"]
   compact(list)
   # list => ["Hello","world"]

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
