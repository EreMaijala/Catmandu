package Catmandu::Fix::retain;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has paths => (fix_arg => 'collect', default => sub {[]});

sub BUILD {
    my ($self) = @_;
    my $builder = $self->builder;
    my $paths   = $self->paths;
    for my $path (@$paths) {
        $builder->shadow($path);
    }
    $builder->delete;
    $builder->unshadow;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::retain - delete everything except the paths given

=head1 SYNOPSIS

   # Keep the field _id , name , title
   retain(_id , name, title)

   # Delete everything except foo.bar 
   #   {bar => { x => 1} , foo => {bar => 1, y => 2}}
   # to
   #   {foo => {bar => 1}}
   retain(foo.bar)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
