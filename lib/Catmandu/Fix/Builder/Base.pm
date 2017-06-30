package Catmandu::Fix::Builder::Base;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Scalar::Util qw(refaddr);
use Moo::Role;
use namespace::clean;

requires 'emit';

sub cancel {
    state $cancel = {};
}

sub cancel_and_delete {
    state $cancel_and_delete = {};
}

sub emit_is_cancel {
    my ($self, $var) = @_;
    my $addr = refaddr($self->cancel);
    "(is_hash_ref(${var}) && Scalar::Util::refaddr(${var}) == $addr)";
}

sub emit_is_cancel_and_delete {
    my ($self, $var) = @_;
    my $addr = refaddr($self->cancel_and_delete);
    "(is_hash_ref(${var}) && Scalar::Util::refaddr(${var}) == $addr)";
}

sub escape_regex {
    my ($self, $str) = @_;
    $str =~ s/\//\\\//g;
    $str =~ s/\\$/\\\\/;    # pattern can't end with an escape
    $str;
}

sub regex {
    my ($self, $str) = @_;
    $str = $self->escape_regex($str);
    qr/$str/;
}

sub substitution {
    my ($self, $search, $replace) = @_;
    $search  = $self->regex($search);
    $replace = $self->escape_regex($replace);
    eval qq|sub {my \$str = \$_[0]; utf8::upgrade(\$str); \$str =~ s/$search/$replace/g; \$str}|;
}

1;

