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

    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $self->cancel unless is_array_ref($val);
            do {
                no warnings 'uninitialized';
                [uniq(@$val)];
            };
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
