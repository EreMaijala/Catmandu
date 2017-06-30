package Catmandu::Fix::flatten;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Catmandu::Util qw(is_array_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_array_ref($val);
            $val = [map {is_array_ref($_) ? @$_ : $_} @$val]
                while grep {is_array_ref($_)} @$val;
            $val;
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::flatten - flatten a nested array field

=head1 SYNOPSIS

   # {deep => [1, [2, 3], 4, [5, [6, 7]]]}
   flatten(deep)
   # {deep => [1, 2, 3, 4, 5, 6, 7]}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
