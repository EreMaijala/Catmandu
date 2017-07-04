package Catmandu::Fix::Builder::Unstash;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has names => (is => 'ro', default => sub {['_']});
has cb => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var, $stash_var) = ($ctx{fixer}, $ctx{var}, $ctx{stash_var});
    if ($self->cb) {
        my $cb_var = $fixer->capture($self->cb);
        my $args   = join(
            ', ',
            map {
                my $key = $fixer->emit_string($_);
                "[reverse(\@{${stash_var}->{${key}} ||= []})]"
            } @{$self->names}
        );
        "${var} = ${cb_var}->(${var}, ${args});" . join(
            '',
            map {
                my $key = $fixer->emit_string($_);
                "splice(\@{${stash_var}->{${key}}}, 0, \@{${stash_var}->{${key}}});"
            } @{$self->names}
        );
    }

    # TODO handle multiple names and no cb
    else {
        my $key = $fixer->emit_string($self->names->[0]);
        "${var} = shift(\@{${stash_var}->{${key}} ||= []});";
    }
}

1;
