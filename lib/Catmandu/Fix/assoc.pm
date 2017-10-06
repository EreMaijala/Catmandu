package Catmandu::Fix::assoc;

use Catmandu::Sane;

our $VERSION = '1.0606';

use Catmandu::Util qw(is_hash_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path      => (fix_arg => 1);
has keys_path => (fix_arg => 1);
has vals_path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;
    my $builder = $self->builder;
    $builder->get($self->keys_path)->stash('keys');
    $builder->get($self->vals_path)->stash('vals');
    $builder->create($self->path)->unstash(
        'keys', 'vals',
        sub {
            my ($val, $keys, $vals) = @_;
            if (is_hash_ref($val //= {})) {
                while (@$keys && @$vals) {
                    $val->{shift @$keys} = shift @$vals;
                }
                $val;
            }
            else {
                # TODO support cancel for unstash
                #$builder->cancel;
                $val;
            }
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::assoc - associate two values as a hash key and value

=head1 SYNOPSIS

   # {pairs => [{key => 'year', val => 2009}, {key => 'subject', val => 'Perl'}]}
   assoc(fields, pairs.*.key, pairs.*.val)
   # {fields => {subject => 'Perl', year => 2009}, pairs => [...]}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
