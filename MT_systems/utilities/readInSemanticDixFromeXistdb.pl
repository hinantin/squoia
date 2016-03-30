#!/usr/bin/perl

use RPC::XML;
use RPC::XML::Client;
use XML::LibXML;
use utf8;                  # Source code is UTF-8
use open ':utf8';
use Storable; # to retrieve hash from disk
# Execute an XQuery through XML-RPC. The query is passed
# to the "executeQuery" method, which returns a handle to
# the created result set. The handle can then be used to
# retrieve results.

$query = <<END;
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
$vars = RPC::XML::struct->new('query' => 'corrupt*');
# Output options
$options = RPC::XML::struct->new(
    'indent' => 'yes', 
    'encoding' => 'UTF-8',
	'variables' => $vars
);

$URL = "http://admin:admin\@localhost:8081/exist/xmlrpc";
print "connecting to $URL...\n";
$client = new RPC::XML::Client $URL;

# Execute the query. The method call returns a handle
# to the created result set.
$req = RPC::XML::request->new("executeQuery", 
    RPC::XML::base64->new($query), 
	"UTF-8", $options);
$resp = process($req);
$result_id = $resp->value;

# Get the number of hits in the result set
$req = RPC::XML::request->new("getHits", $result_id);
$resp = process($req);
$hits = $resp->value;
print "Found $hits hits.\n";
my %lexEntriesWithFrames = ();
# Retrieve query results 1 to 10
for($i = 1; $i < $hits && $i < $hits; $i++) {
    $req = RPC::XML::request->new("retrieve", $result_id, $i, $options);
    $resp = process($req);
    #print $resp->value . "\n";
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
    my($request) = @_;
    $response = $client->send_request($request);
    if($response->is_fault) {
        die "An error occurred: " . $response->string . "\n";
    }
    return $response;
}
