package Catmandu::Fix::count;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use Catmandu::Util qw(is_array_ref is_hash_ref);
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->get($self->path);
    $builder->if(\&is_array_ref)->update(sub {
        my $val = $_[0];
        scalar(@$val);
    });
    $builder->if(\&is_hash_ref)->update(sub {
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
