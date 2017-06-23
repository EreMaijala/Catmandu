package Catmandu::Fix::Builder;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Scalar::Util qw(refaddr);
use Catmandu::Fix::Builder::Get;
use Catmandu::Fix::Builder::Set;
use Catmandu::Fix::Builder::Create;
use Catmandu::Fix::Builder::Update;
use Catmandu::Fix::Builder::Delete;
use Catmandu::Fix::Builder::If;
use Moo;
use namespace::clean;

with 'Catmandu::Fix::Base';

has steps => (is => 'lazy', default => sub { [] });

sub get {
    my ($self, $path) = @_;
    my $step = Catmandu::Fix::Builder::Get->new({path => $path});
    push @{$self->steps}, $step;
    $step;
}

sub set {
    my ($self, $path, $value) = @_;
    my $step = Catmandu::Fix::Builder::Set->new({path => $path, value => $value});
    push @{$self->steps}, $step;
    $step;
}

sub create {
    my ($self, $path) = @_;
    my $step = Catmandu::Fix::Builder::Create->new({path => $path});
    push @{$self->steps}, $step;
    $step;
}

sub delete {
    my ($self, $path) = @_;
    my $step = Catmandu::Fix::Builder::Delete->new({path => $path});
    push @{$self->steps}, $step;
    $self;
}

sub if {
    my ($self, $condition) = @_;
    my $step = Catmandu::Fix::Builder::If->new({condition => $condition});
    push @{$self->steps}, $step;
    $step;
}

my $cancel = [];
my $cancel_delete = [];

sub cancel {
    my ($self, %opts) = @_;
    $opts{delete} ? $cancel_delete : $cancel;
}

sub emit_is_cancel {
    my ($self, $var) = @_;
    my $addr = refaddr($cancel);
    "is_array_ref(${var}) && Scalar::Util::refaddr(${var}) == $addr";
}

sub emit_is_cancel_delete {
    my ($self, $var) = @_;
    my $addr = refaddr($cancel_delete);
    "is_array_ref(${var}) && Scalar::Util::refaddr(${var}) == $addr";
}

sub emit_steps {
    my ($self, @args) = @_;
    join '', map { $_->emit(@args) } @{$self->steps};
}

sub emit {
    my ($self, @args) = @_;
    $self->emit_steps(@args);
}

1;
