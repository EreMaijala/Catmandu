package Catmandu::Fix::move_field;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has old_path => (fix_arg => 1);
has new_path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;
    my $builder = $self->builder;
    $builder->get($self->old_path)->stash->delete;
    $builder->create($self->new_path)->unstash;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::move_field - move a field to another place in the data structure

=head1 SYNOPSIS

   # Move single fields

   # Move 'foo.bar' to 'bar.foo'
   move_field(foo.bar, bar.foo)

   # Move multipe fields
   # Data:
   # a:
   #   b: test1
   #   c: test2
   move_field(a,z)  # -> Move all the 'a' to 'z'
                    # z:
                    #   b: test1
                    #   c: test2
   # Data:
   # a:
   #   b: test1
   #   c: test2
   move_field(a,.)  # -> Move the fields 'b' and 'c' to the root
                    # b: test1
                    # c: test2

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
