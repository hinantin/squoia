#!/usr/bin/perl

use IO::Socket::INET;
use IO::File;
use utf8; # Source code is UTF-8
binmode STDIN, ':utf8';
binmode STDERR, ':utf8';
binmode STDOUT, ':utf8';
use Getopt::Long qw(GetOptions);

# --- Options
my $options = "[--port|-P <INT>] [--host|-H <STRING>] [--stdin] [--file|-f <DOCUMENT>]";

my $port;
my $host;
my $stdin;
my $file;

GetOptions (
'port|P=s' => \$port,
'host|H=s' => \$host,
'stdin' => \$stdin,
'file|f=s' => \$file,
) or die " Usage:  $0 $options\n";
if ((not defined $stdin) and (not defined $file)) {
  print STDERR "* Usage:  $0 $options\n‐‐stdin not activated for getting data from a file --file \n";
  exit;
}

my $text;
my $buffsize = 80000;
my $inputdata = "";
my $outputdata = "";

if (defined $stdin) {
 while (<>) {
  if (/^$/) {
    # auto-flush on socket
    $| = 1;
    $inputdata .= $_;
    # create a connecting socket
    my $socket = new IO::Socket::INET (PeerHost => $host, PeerPort => $port, Proto => 'tcp',);
    print STDERR "Host: $host, Port: $port\n";
    binmode($socket, ":utf8");
    my $message = "";
    die "cannot connect to the server $!\n" unless $socket;
    $message = "connected to the server";

    # data to send to a server
    my $size = $socket->send($inputdata);
    $message = "$message, sent data of length $size";

    # notify server that request has been sent
    shutdown($socket, 1);

    # receive a response of up to 1024 characters from server
    my $response = "";
    $socket->recv($response, $buffsize);
    $outputdata .= $response;

    $socket->close();
    $inputdata = "";
  } else {
    $inputdata .= $_;
  }
 }
}
else {
  # -- Getting data from file
  if (not defined $file) {
    print STDERR " Usage:  $0 $options\n‐‐stdin not activated for getting data from a file --file \n";
    exit;
  }
  else {
    open (TEXT, $file) or die "Can't open file \"$file\" to write: $!\n";
    while (<TEXT>) { 

  if (/^$/) {
    # auto-flush on socket
    $| = 1;
    $inputdata .= $_;
    # create a connecting socket
    my $socket = new IO::Socket::INET (PeerHost => $host, PeerPort => $port, Proto => 'tcp',);
    print STDERR "Host: $host, Port: $port\n";
    binmode($socket, ":utf8");
    my $message = "";
    die "cannot connect to the server $!\n" unless $socket;
    $message = "connected to the server";

    # data to send to a server
    my $size = $socket->send($inputdata);
    $message = "$message, sent data of length $size";

    # notify server that request has been sent
    shutdown($socket, 1);

    # receive a response of up to 1024 characters from server
    my $response = "";
    $socket->recv($response, $buffsize);
    $outputdata .= $response;

    $socket->close();
    $inputdata = "";
  } else {
    $inputdata .= $_;
  }

    }
    #open (TMP, ">:encoding(UTF-8)", $file) or die "Can't open temporary file \"$file\" to write: $!\n";
    #while(<>){print TMP $_;}

  }
}

print "$outputdata";
print STDERR "$outputdata";
