package Catmandu::Importer::HTTPError;

use Catmandu::Sane;
use Moo;
use namespace::clean;

with 'Catmandu::Importer';

has code => (is => 'ro', default => sub {'404'});

sub generator {
    my ($self) = @_;
    sub {
        Catmandu::HTTPError->throw(
            code => $self->code,
            url => 'http://localhost',
            method => 'GET',
            request_headers => [],
            request_body => '',
            response_headers => [],
            response_body => $self->code,
        );
    };
}

1;
