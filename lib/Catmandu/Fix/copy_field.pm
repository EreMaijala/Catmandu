package Catmandu::Fix::copy_field;

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
    $builder->get($self->old_path)->stash;
    $builder->create($self->new_path)->unstash;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::copy_field - copy the value of one field to a new field

=head1 SYNOPSIS

   # Copy the values of foo.bar into bar.foo
   copy_field(foo.bar, bar.foo)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
