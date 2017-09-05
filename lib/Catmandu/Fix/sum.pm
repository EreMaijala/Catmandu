package Catmandu::Fix::sum;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Catmandu::Util qw(is_number is_array_ref);
use List::Util qw(all sum);
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
            return $builder->cancel
                unless is_array_ref($val) && all {is_number($_)} @$val;
            sum(@$val) // 0;
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::sum - replace the value of an array field with the sum of its elements

=head1 SYNOPSIS

   # e.g. numbers => [2, 3]
   sum(numbers)
   # numbers => 5

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
