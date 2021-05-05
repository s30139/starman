package Plack::Middleware::CheckResponse;
use parent qw(Plack::Middleware);
use Plack::Util;

sub call {
    my($self, $env) = @_;
    my $res  = $self->app->($env);
    return Plack::Util::response_cb($res, sub {
        my $res = shift;
        #$res->[0] = 500;
        warn "404" if $res->[0] != 200;
        return;
    });
}

1;
