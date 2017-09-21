package Catmandu::Fix::uniq;

use Catmandu::Sane;

our $VERSION = '1.0605';

use Catmandu::Util qw(is_array_ref);
use List::MoreUtils qw(uniq);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    $self->builder->get($self->path)->if('is_array_ref')->update(
        sub {
            no warnings 'uninitialized';
            [uniq(@{$_[0]})];
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::uniq - strip duplicate values from an array

=head1 SYNOPSIS

   # {tags => ["foo", "bar", "bar", "foo"]}
   uniq(tags)
   # {tags => ["foo", "bar"]}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
