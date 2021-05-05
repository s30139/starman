package Plack::Middleware::Only;
use strict;
use warnings;
use parent qw/Plack::Middleware/;

use Plack;
use Plack::Response;
use Plack::Request;

sub call {
    my ($self, $env) = @_;

    my $req = Plack::Request->new($env);

    my $method = $self->{method};

    warn "method <$method>";

    $method ||= 'ANY';

    if ($method ne 'ANY' && $req->method() ne $method) {
        my $new_res = $req->new_response(405);
        $new_res->body('Method not allowed');
        return $new_res->finalize();
    }

    #my $plack_res = $self->app->($env);
    #$plack_res->[2]->[0] .= 'ALLOWED';
    #return $plack_res;
    return $self->app->($env);
}

1;
