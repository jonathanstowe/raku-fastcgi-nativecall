use v6;
use NativeCall;

class FCGX_Request is repr('CPointer') { }

sub FCGX_Init()
is native('fcgi.so') returns int32 { ... }

sub FCGX_InitRequest(FCGX_Request $request, int32 $sock, int32 $flags)
is native('fcgi.so') returns int32 { ... }

sub FCGX_OpenSocket(Str $path, int32 $backlog)
is native('fcgi.so') returns int32 { ... }

sub FCGX_Accept_r(FCGX_Request $fcgx_req)
is native('fcgi.so') returns int32 { ... }

sub XS_Init(int32 $sock)
is native('fcgi.so') returns FCGX_Request { ... }

sub XS_Print(Str $str, FCGX_Request $request)
is native('fcgi.so') returns int32 { ... }

class FCGI {
	has FCGX_Request $!fcgx_req;

	method new(Int $sock) {
		return self.bless(:$sock);
	}

	submethod BUILD(:$sock) {
		$!fcgx_req = XS_Init($sock);
	}

	our sub OpenSocket(Str $path, Int $backlog) {
		return FCGX_OpenSocket($path, $backlog);
	}

	method Accept() {
		return FCGX_Accept_r($!fcgx_req);
	}

	method Print(Str $content) {
		return XS_Print($content, $!fcgx_req);
	}
}	

# vim: ft=perl6
