package Catmandu::Fix::hash;

use Catmandu::Sane;

our $VERSION = '1.0603';

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
            +{@$val};
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::hash - creates a hash out of an array

=head1 SYNOPSIS

   # tags => ['name', 'Peter', 'age', 12]
   hash(tags)
   # tags => {name => 'Peter', age => 12}

=head1 DESCRIPTION

This fix functions transforms array fields to hashes. The number of array
elements must be even and fields to be used as field values must be simple
strings. String fields and hash fields are left unchanged.

=head1 SEE ALSO

L<Catmandu::Fix::array>, L<Catmandu::Fix>

=cut
