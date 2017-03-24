package Org;

use Modern::Perl '2015';
use autodie;

sub format_entry {
    my %p = (
        level => 0,
        todo_keyword => "",
        title => "",
        tags => [],
        body => "",
        @_);

    return %p{ body } unless $p{ level };

    my $max_title_length = 80; # TODO: move out as a parameter

    my $level = ('*' x $p{level}) . ' ';

    my $title = $p{title};
    $title =  join ' ', $p{todo_keyword}, $title if $p{todo_keyword};

    my $tags = join ':', @{ $p{tags} };
    $tags = " :$tags:" if $tags;

    my $padding =
        $max_title_length - (length $level)
        - (length $title) - (length $tags);

    $padding = 0 unless $tags;

    my $body = $p{body};
    chomp $body;

    my $formatted =  $level . $title . (' ' x $padding) . $tags . "\n";
    $formatted = $formatted . $body . "\n" if $body;

    return  $formatted;
}

sub parse_entry {
    my ($entry) = @_;

    my $entry_regex;
    {
        my $todo   = '(?P<todo>TODO|NEXT|DONE) ';
        my $title  = '(?P<title>.*)';
        my $tags   = ':(?P<tags>.*):';
        my $body   = '(?P<body>(?s).*)';
        my $level  = '(?P<level>\*+) ';

        my $header = "^($level)($todo)?($title)\\s*($tags)?";

        $entry_regex = "(($header\\n$body)|($body))";
    }

    my %parsed;

    if ($entry !~ $entry_regex) {
        return \%parsed;
    }

    $parsed{ level }        = length $+{level};
    $parsed{ todo_keyword } = $+{todo};
    $parsed{ title }        = $+{title};
    $parsed{ tags }         = $+{tags};
    $parsed{ body }         = $+{body};

    while ( my ( $key, $val ) = each %parsed ) {
        delete $parsed{ $key } if not defined $val;
    }

    return \%parsed;
}

sub parse_file {
  my ($file_str) = @_;

  my @entries;
  my @current_entry;
  my $flush_entry = sub {
      if (@current_entry) {
          # TODO: remove join, implement parse_entry for arrays
          push @entries, parse_entry(join "\n", @current_entry);
          splice(@current_entry);
      }
  };

  foreach my $line (split "\n", $file_str) {
      if ($line =~ /\* (.*)/) {
          # found header

          # when header is reached it is either the first entry in a
          # file, or it is an end of a current entry
          $flush_entry->();
      }

      push @current_entry, $line;
  }

  # handle the last entry as well
  $flush_entry->();

  return \@entries;
}

1;
