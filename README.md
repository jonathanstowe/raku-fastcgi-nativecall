# FCGI #

This is an implementation of FastCGI for Perl 6 using NativeCall

## Example ##

	use FCGI;

	my $sock = FCGI::OpenSocket("/var/www/run/example.sock", 5);
	my $fcgi = FCGI.new($sock);

	my $count = 0;

	while ($fcgi.Accept() >= 0) {
		$fcgi.Print("Content-Type: text/html\r\n\r\n{++$count}");
	}
