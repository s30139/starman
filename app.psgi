use strict;
use warnings;

use Plack;
use Plack::Builder;
use Plack::Request;

use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;
use POSIX qw(strftime);
use JSON::XS;

use FindBin;
use lib "$FindBin::Bin/lib";

use Plack::Middleware::Only;

my $put = sub {
    my $env = shift;

    my $req = Plack::Request->new($env);

    my $body = $req->content(); # get body
    my $params = decode_json($body);

    my $json = {
        put => 'put'
    };

    my $res = $req->new_response(200);
    $res->body( encode_json($json) );
    return $res->finalize();
};

my $create = sub {
    my $env = shift;

    my $req = Plack::Request->new($env);
    my $body = $req->content();
    my $params = decode_json($body);

    my $json = {
        post => 'create'
    };

    my $res = $req->new_response(200);
    $res->body( encode_json($json) );
    return $res->finalize();
};

my $get = sub {
    my $env = shift;

    my $req = Plack::Request->new($env);
    my $body = $req->content();
    my $params = decode_json($body);

    my $json = {
        get => 'get'
    };

    my $res = $req->new_response(200);
    $res->body( encode_json($json) );
    return $res->finalize();
};




# API
my $app = builder {
    enable "CheckResponse";
    mount "/post" => builder {
        enable "Only", method => 'POST';
        mount "/create" => builder {
            $create;
        };
        mount "/put" => builder {
            $put;
        };
    };
    mount "/get" => builder {
        enable "Only", method => 'GET';
        mount "/get/all" => builder {
            $get;
        };
    };
};
