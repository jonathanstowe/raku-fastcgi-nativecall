use v6;

use Test;
use FastCGI::NativeCall;

plan 2;

class MockedFastCGI is FastCGI::NativeCall {
    method Print(Str $in) returns Str {
        return $in;
    }
}

sub sock-path(--> Str) {
    $*PID ~ '-' ~ now.Int ~ '.sock';
}

subtest {
    my $path = sock-path();
    my $fcgi = MockedFastCGI.new(:$path, backlog => 10);

    my %header =
        Content-Type => 'text/html; charset=UTF-8',
        Accept => '*/*',
        Content-length => 1982,
        ETag => '33a64df551425fcc55e4d42a148795d9f25f89d4',
        Set-Cookie => 'cookie1=1'
    ;

    my $printed_header = $fcgi.header(%header);

    for %header.kv -> $key, $value {
        ok $printed_header ~~ /"$key: $value\r\n"/, "header member $key";
    }

    LEAVE {
        unlink($path);
    }
}, "check single cookie";

subtest {
    my $path = sock-path();
    my $fcgi = MockedFastCGI.new(:$path, backlog => 10);

    my %header =
        Content-Type => 'text/html; charset=UTF-8',
        Accept => '*/*',
        Content-length => 1982,
        ETag => '33a64df551425fcc55e4d42a148795d9f25f89d4',
        Set-Cookie => ['cookie1=1', 'cookie2=2', 'cookieN=N']
    ;

    my $printed_header = $fcgi.header(%header);

    for %header.kv -> $key, $value {
        if $value ~~ Array {
            $value.map({
                my $member = $_;
                ok $printed_header ~~ /"$key: $member\r\n"/, "header multiple member $key";
            });
        }
        else {
            ok $printed_header ~~ /"$key: $value\r\n"/, "header member $key";
        }
    }

    LEAVE {
        unlink($path);
    }
}, "check miltiple cookies";

done-testing;
