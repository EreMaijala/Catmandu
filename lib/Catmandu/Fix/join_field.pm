package Catmandu::Fix::join_field;

use Catmandu::Sane;

our $VERSION = '1.0604';

use Catmandu::Util qw(is_value is_array_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);
has join_char => (fix_arg => 1, default => sub {''});

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder   = $self->builder;
    my $join_char = $self->join_char;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_array_ref($val);
            join($join_char, grep {is_value($_)} @$val);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::join_field - join the ARRAY values of a field into a string

=head1 SYNOPSIS

   # Join the array values of a field into a string. E.g. foo => [1,2,3]
   join_field(foo, /) # foo => "1/2/3"

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
