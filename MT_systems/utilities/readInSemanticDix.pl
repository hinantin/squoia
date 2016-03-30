#!/usr/bin/perl

use utf8; # Source code is UTF-8
use open ':utf8';
use Storable; # to retrieve hash from disk
#binmode STDIN, ':utf8';
#binmode STDOUT, ':utf8';
use strict;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  print "\nUsage:  perl readInSemanticDix.pl path-to-noun-lexicon (lemma:tag)\n";
  exit;
}

my $nounLex = $ARGV[1];

open NOUNS, "< $nounLex" or die "Can't open $nounLex : $!";

my %nounLex = ();

while(<NOUNS>)
{
	s/#.*//;     # no comments
	(my $lemma, my $semTag) = split(/:/,$_);
	$nounLex{$lemma} = $semTag;
}

store \%nounLex, 'NounLex';

