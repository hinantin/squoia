#!/usr/bin/perl

use strict;
use utf8; # Source code is UTF-8
use open ':utf8';
use RPC::XML;
use RPC::XML::Client;
use XML::LibXML;
use Storable; # to retrieve hash from disk
use Config::IniFiles;
use Getopt::Long qw(GetOptions);

my $configfile;
my $options = "[--config-file path-to-config-file]";
GetOptions (
'config-file=s' => \$configfile,
) or die " Usage: $0 $options\n";

if (!defined $configfile) {
  print STDERR " Usage: $0 $options\n";
  exit;
}

my $query = <<END;
let \$documents := '/db/MT_Systems/ancoralex/verb-es'
for \$doc in collection(\$documents)
for \$lexentry in \$doc//lexentry
  let \$lemma := data(\$lexentry//\@lemma)
  return 
  <type lemma="{\$lemma}"> {
  for \$frame in \$lexentry//descendant::frame
    let \$lss := data(\$frame/\@lss)
    let \$type := data(\$frame/\@type)
    let \$thematicRoleOfSubj := \$frame//child::argument[\@function eq 'suj'][1]/\@thematicrole
    return 
        if (\$type ne 'resultative') then ( <lsstype value="{ concat(\$lss, '#', \$type, '##', \$thematicRoleOfSubj) }" /> )
        else ()
  } </type>
END

# user-supplied variables
my $vars = RPC::XML::struct->new('query' => 'corrupt*');
# Output options
my $options = RPC::XML::struct->new(
    'indent' => 'yes', 
    'encoding' => 'UTF-8', 
    'variables' => $vars
);

my $CONFIG = Config::IniFiles->new( -file => $configfile );
my $host = $CONFIG->val( 'EXISTDBDATABASE', 'HOST' );
my $port = $CONFIG->val( 'EXISTDBDATABASE', 'PORT' );
my $user = $CONFIG->val( 'EXISTDBDATABASE', 'USER' );
my $password = $CONFIG->val( 'EXISTDBDATABASE', 'PASSWORD' );

my $URL = "http://$user:$password\@$host:$port/exist/xmlrpc";
print "connecting to $URL...\n";
my $client = new RPC::XML::Client $URL;

# Execute the query. The method call returns a handle
# to the created result set.
my $req = RPC::XML::request->new(
    "executeQuery", 
    RPC::XML::base64->new($query), 
    "UTF-8", 
    $options
);
my $resp = process($req);
my $result_id = $resp->value;

# Get the number of hits in the result set
$req = RPC::XML::request->new("getHits", $result_id);
$resp = process($req);
my $hits = $resp->value;
print "Found $hits hits.\n";
my %lexEntriesWithFrames = ();
for(my $i = 1; $i < $hits && $i < $hits; $i++) {
    $req = RPC::XML::request->new("retrieve", $result_id, $i, $options);
    $resp = process($req);
    my $dom    = XML::LibXML->load_xml( string => $resp->value );
    my @typesList = $dom->getElementsByTagName('type');

    foreach my $type (@typesList)
    {
      my $lemma = $type->getAttribute('lemma');
      my @lsstypes = $type->findnodes('descendant::lsstype');
      my @types = ();
      foreach my $lsstype (@lsstypes)
      {
        my $value = $lsstype->getAttribute('value') . " \n";
        push(@types, $value);
      }
      $lexEntriesWithFrames{$lemma} = \@types;
    }
}
store \%lexEntriesWithFrames, 'VerbLex';

# We release the result set handle
$req = RPC::XML::request->new("releaseQueryResult", $result_id);
process($req);

# Send the request and check for errors
sub process {
    my ($request) = @_;
    my $response = $client->send_request($request);
    if($response->is_fault) {
        die "An error occurred: " . $response->string . "\n";
    }
    return $response;
}
