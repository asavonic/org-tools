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

    my $max_title_length = 80; # TODO: move out

    my $title = join ' ', $p{todo_keyword}, $p{title};

    my $tags = join ':', @{ $p{tags} };
    $tags = " :$tags:" if $tags;

    my $padding = $max_title_length - (length $title) - (length $tags);

    chomp $p{body};

    return $title . (' ' x $padding) . $tags . "\n" . $p{body} . "\n";
}


1;
