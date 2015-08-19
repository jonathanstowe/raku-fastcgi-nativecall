use v6;
use NativeCall;

class FCGX_Request is repr('CPointer') { }

sub FCGX_Init()
is native('fcgi') returns int32 { ... }

sub FCGX_InitRequest(FCGX_Request $request, int32 $sock, int32 $flags)
is native('fcgi') returns int32 { ... }

sub FCGX_OpenSocket(Str $path, int32 $backlog)
is native('fcgi') returns int32 { ... }

sub FCGX_Accept_r(FCGX_Request $fcgx_req)
is native('fcgi') returns int32 { ... }

sub XS_Init(int32 $sock)
is native('fcgi') returns FCGX_Request { ... }

sub XS_Print(Str $str, FCGX_Request $request)
is native('fcgi') returns int32 { ... }

sub XS_set_populate_env_callback(&callback (Str, Str))
is native('fcgi') { ... }

sub XS_populate_env(FCGX_Request $request)
is native('fcgi') { ... }

class FCGI {
	has FCGX_Request $!fcgx_req;
	my %env;

	method env { %env; }

	my sub populate_env(Str $key, Str $value) {
		%env{$key} = $value;
	}

	method new(Int $sock) {
		return self.bless(:$sock);
	}

	submethod BUILD(:$sock) {
		$!fcgx_req = XS_Init($sock);
		XS_set_populate_env_callback(&populate_env);
	}

	our sub OpenSocket(Str $path, Int $backlog) {
		return FCGX_OpenSocket($path, $backlog);
	}

	method Accept() {
		%env = ();
		my $ret = FCGX_Accept_r($!fcgx_req);
		XS_populate_env($!fcgx_req);
		$ret;
	}

	method Print(Str $content) {
		XS_Print($content, $!fcgx_req);
	}
}	

# vim: ft=perl6
