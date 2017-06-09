package Catmandu::Fix::trim;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Catmandu::Util qw(trim is_string);
use Unicode::Normalize;
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);
has mode => (fix_arg => 1, default => sub {'whitespace'});

sub BUILD {
    my ($self) = @_;

    my $cb;
    if ($self->mode eq 'whitespace') {
        $cb = \&trim;
    }
    elsif ($self->mode eq 'nonword') {
        $cb = sub {
            my $val = $_[0];
            $val =~ s/^\W+//;
            $val =~ s/\W+$//;
            $val;
        };
    }
    elsif ($self->mode eq 'diacritics') {
        $cb = sub {
            my $val = Unicode::Normalize::NFKD($_[0]);
            $val =~ s/\p{NonspacingMark}//g;
            $val;
        };
    }

    $self->get($self->path)->if(\&is_string)->set($cb);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Catmandu::Fix::trim - trim leading and ending junk from the value of a field

=head1 SYNOPSIS

   # the default mode trims whitespace
   # e.g. foo => '   abc   ';

   trim(foo) # foo => 'abc';
   trim(foo, whitespace) # foo => 'abc';
   
   # trim non-word characters
   # e.g. foo => '   abc  / : .';
   trim(foo, nonword) # foo => 'abc';

   # trim accents
   # e.g. foo => 'français' ;
   trim(foo,diacritics) # foo => 'francais'
   
=head1 SEE ALSO

L<Catmandu::Fix>

=cut
