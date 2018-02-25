#!/usr/bin/perl

use strict;
use warnings;

use LWP::Simple;
use LWP::UserAgent;
use Data::Dumper;

my $ua = new LWP::UserAgent;
$ua->agent("Mozilla/8.0");

sub trim
{
  my $s = shift;
  $s =~ s/^\s+|\s+$//g;
  return $s
}

my @lyrics;

if(@lyrics = @ARGV){}
else
{
  die "zlyrics requires lyrics.\n";
}

my $lyrics = join "+",@lyrics;

my $html = get("https://search.azlyrics.com/search.php?q=$lyrics");
my @html;
my @newHtml;

if ($html =~/1\. <a href="(.+)" target="_blank">/)
{
  $html = get($1);
  @html = split /\n/, $html;

  for my $i (0..$#html)
  {
    if ($html[$i] =~ /<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->/)
    {
      push @newHtml, $html[$i] and ++$i until($html[$i] =~ /<\/div>/);
    }
  }
}
else
{
  print Dumper \$html;
    die;
  die "Lyrics not found.\n";
}

my $output = join "\n", @newHtml;

$output =~ s/<i>//g;
$output =~ s/<\/i>//g;
$output =~ s/<b>//g;
$output =~ s/<\/b>//g;
$output =~ s/<br>//g;
$output =~ s/<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->//;


print $output;
