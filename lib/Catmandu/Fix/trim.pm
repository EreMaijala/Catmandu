package Catmandu::Fix::trim;

use Catmandu::Sane;

our $VERSION = '1.0606';

use Catmandu::Util qw(trim is_string);
use Unicode::Normalize;
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);
has mode => (fix_arg => 1, default => sub {'whitespace'});

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $cb;
    if ($self->mode eq 'whitespace') {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_string($val);
            trim($val);
        };
    }
    elsif ($self->mode eq 'nonword') {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_string($val);
            $val =~ s/^\W+//;
            $val =~ s/\W+$//;
            $val;
        };
    }
    elsif ($self->mode eq 'diacritics') {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_string($val);
            $val = Unicode::Normalize::NFKD($val);
            $val =~ s/\p{NonspacingMark}//g;
            $val;
        };
    }

    $builder->get($self->path)->update($cb);
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
