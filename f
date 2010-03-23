#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Std;

my %o = ( d => "\t" );
getopts('d:', \%o);
my $opt_d = $o{d};

# get the fields to print
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
    # get the contents of the fields
    chomp;

    # Handle CRLF line endings. Without this, the CR would get caught in the
    # final field, and if printed before another field, would mess everything
    # up. (A CR anywhere else will still do that.)
    my $lf = "\n";
    if (/\r$/) {
	    $lf = "\r\n";
	    chop;
    }

    my @F = split $opt_d;
    my $l = scalar @F;
    my @fields = ();
    for my $a (@list) {
	my ($s, $e) = @$a;

	# If we have a positive and a negative endpoint, and if the positive
	# value is larger than the number of fields, don't do anything.
	# Without this bit we would simply print the final field.
	next if ($s >= 0 && $e < 0 && $s >= $l)
		|| ($e >= 0 && $s < 0 && $e >= $l);

	$s = $l + $s if $s < 0;
	$e = $l + $e if $e < 0;
	my @flist = $s > $e ? reverse($e..$s) : $s..$e;
	for my $x (@flist) {
	    push @fields, $F[$x] if $l > $x;
	}
    }

    # print them.
    while($#fields > 0) {
	print shift(@fields), $opt_d;
    }
    print shift(@fields), $lf if $#fields != -1;
}
