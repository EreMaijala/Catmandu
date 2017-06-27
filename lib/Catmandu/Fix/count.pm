package Catmandu::Fix::count;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Moo;
use Catmandu::Util qw(is_array_ref is_hash_ref);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(sub {
        my $val = $_[0];
        if (is_array_ref($val)) {
            scalar(@$val);
        } elsif (is_hash_ref($val)) {
            scalar(keys %$val);
        } else {
            $builder->cancel;
        }
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
