package Org;

use Modern::Perl '2015';
use autodie;

sub format_entry {
    my %p = (
        todo_keyword => "",
        title => "",
        body => "",
        tags => [],
        @_);

    my $max_title_length = 80; # TODO: move out as a parameter

    my $title = $p{title};
    $title =  join ' ', $p{todo_keyword}, $title if $p{todo_keyword};

    my $tags = join ':', @{ $p{tags} };
    $tags = " :$tags:" if $tags;

    my $padding = $max_title_length - (length $title) - (length $tags);
    $padding = 0 unless $tags;

    my $body = $p{body};
    chomp $body;

    my $formatted = $title . (' ' x $padding) . $tags . "\n";
    $formatted = $formatted . $body . "\n" if $body;

    return  $formatted;
}
}


1;
