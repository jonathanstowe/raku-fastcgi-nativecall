use v6;
use Panda::Common;
use Panda::Builder;
use Shell::Command;

class Build is Panda::Builder {
	method build($dir) {
		my Str $ext = "$dir/ext";
		my Str $blib = "$dir/blib";
		rm_f("$ext/fcgi.so");
		rm_rf($blib);
		mkdir($blib);
		mkdir("$blib/lib");
		my $here = $*CWD;
		chdir($ext);
		shell("./configure");
		shell("make");
		chdir($here);
		cp("$ext/fcgi.so", "$blib/lib/fcgi.so");
	}
}
