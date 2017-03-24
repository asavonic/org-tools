package Org;

use Modern::Perl '2015';
use autodie;

sub format_entry {
    my %p = (
        level => 1,
        todo_keyword => "",
        title => "",
        body => "",
        tags => [],
        @_);

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


1;
