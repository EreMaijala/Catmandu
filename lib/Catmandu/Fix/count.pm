package Catmandu::Fix::count;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use Types::Standard qw(ArrayRef HashRef);
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->at($self->path);
    $builder->if(ArrayRef)->set(sub {
        my $val = $_[0];
        scalar(@$val);
    });
    $builder->if(HashRef)->set(sub {
        my $val = $_[0];
        scalar(keys %$val);
    });
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::count - replace the value of an array or hash field with its count

=head1 SYNOPSIS

   # e.g. tags => ["foo", "bar"]
   count(tags) # tags => 2

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
