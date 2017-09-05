package Catmandu::Fix::reverse;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Catmandu::Util qw(is_string is_array_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;
    my $builder = $self->builder;
    $builder->get($self->path)->update(sub {
        my $val = $_[0];
        if (is_array_ref($val)) {
            [reverse(@$val)];
        } elsif (is_string($val)) {
            scalar(reverse($val));
        } else {
            $builder->cancel;
        }
    });
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::reverse - reverse a string or an array

=head1 SYNOPSIS

   # {author => "tom jones"}
   reverse(author)
   # {author => "senoj mot"}

   # {numbers => [1,14,2]}
   reverse(numbers)
   # {numbers => [2,14,1]}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
