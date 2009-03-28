#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Std;

my %o = ( d => "\t" );
getopt('d', \%o);
my $opt_d = $o{d};

my @list = ();
my @ranges = split(/,/, shift());
for my $rn (@ranges) {
    my ($l, $r);
    if ($rn =~ /:/) {
	($l, $r) = split(/:/, $rn);
	$l = "1" if $l eq "";
	$r = "-1" if $r eq "";
	$l = int($l);
	$r = int($r);
    } else {
	$l = $r = int($rn);
    }
    $l -= 1 if $l > 0;
    $r -= 1 if $r > 0;
    push(@list, [$l, $r]);
}

while (<>) {
    chomp;
    my @F = split $opt_d;
    my $l = scalar @F;
    my @fields = ();
    for my $a (@list) {
	my ($s, $e) = @$a;
	$s = $l + $s if $s < 0;
	$e = $l + $e if $e < 0;
	my @flist = $s > $e ? reverse($e..$s) : $s..$e;
	for my $x (@flist) {
	    push @fields, $F[$x] if $l > $x;
	}
	#push @fields, @F[ ($s > $e ? reverse($e..$s) : $s..$e) ];
    }

    while($#fields > 0) {
	print shift(@fields), $opt_d;
    }
    print shift(@fields), "\n" if $#fields != -1;
}

