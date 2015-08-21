use v6;
use Test;
use FCGI;

plan 2;

my $sock = FCGI::OpenSocket('01-test.sock', 5);
ok '01-test.sock'.IO ~~ :e, 'opened socket';

my $fcgi = FCGI.new($sock);
ok $fcgi, 'created objected';

unlink('01-test.sock');

# vim: ft=perl6
