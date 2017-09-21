package Catmandu::Fix::index;

use Catmandu::Sane;

our $VERSION = '1.0605';

use Moo;
use List::MoreUtils qw(indexes first_index);
use Catmandu::Util qw(is_string is_array_ref);
use namespace::clean;
use Catmandu::Fix::Has;

has path     => (fix_arg => 1);
has search   => (fix_arg => 1);
has multiple => (fix_opt => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $search  = $self->search;
    my $cb;
    if ($self->multiple) {
        $cb = sub {
            my $val = $_[0];
            if (is_string($val)) {
                [indexes {$_ eq $search} unpack('(A)*', $val)];
            }
            elsif (is_array_ref($val)) {
                [indexes {$_ eq $search} @$val];
            }
            else {
                $builder->cancel;
            }
        };
    }
    else {
        $cb = sub {
            my $val = $_[0];
            if (is_string($val)) {
                index($val, $search);
            }
            elsif (is_array_ref($val)) {
                first_index {$_ eq $search} @$val;
            }
            else {
                $builder->cancel;
            }
        };
    }

    $builder->get($self->path)->update($cb);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::index - Find all positions of a (sub)string in a field

=head1 SYNOPSIS

   # On strings, search the occurence of a character in a string

   # word => "abcde"
   index(word,'c')                   # word => 2
   index(word,'x')                   # word => -1

   # word => "abccde"
   index(word,'c', multiple:1)       # word => [2,3]

   # word => [a,b,bba] , loop over all word(s) with the '*'
   index(word.*,'a')                 # word -> [0,-1,2]

   # On arrays, search the occurence of a word in an array

   # words => ["foo","bar","foo"]
   index(words,'bar')                # words => 1
   index(words,'foo', multiple: 1)   # words => [0,2]

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
