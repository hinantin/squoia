#!/usr/bin/perl

use utf8; # Source code is UTF-8
use open ':utf8';
use Storable; # to retrieve hash from disk
#binmode STDIN, ':utf8';
#binmode STDOUT, ':utf8';
use strict;
use Getopt::Long qw(GetOptions);

my $nounlex;
my $options = "[--noun-lex path-to-noun-lexicon (lemma:tag)]";

GetOptions (
'noun-lex=s' => \$nounlex,
) or die " Usage: $0 $options\n";

if (!defined $nounlex) {
  print STDERR " Usage: $0 $options\n";
  exit;
}

open NOUNS, "< $nounlex" or die "Can't open $nounlex : $!";
my %nounLex = ();

while(<NOUNS>)
{
	s/#.*//;     # no comments
	(my $lemma, my $semTag) = split(/:/,$_);
	$nounLex{$lemma} = $semTag;
}

store \%nounLex, 'NounLex';

