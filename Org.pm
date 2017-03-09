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

sub parse_entry {
    my ($entry) = @_;

    my %p;

    $entry =~ /^((TODO|NEXT|DONE) )?(.*)\s*(:(.*):)?/;
    $p{ todo_keyword } = $2 if $2;
    $p{ title } = $3 if $3;
    $p{ tags } = [split ':', $5] if $5;

    return \%p unless %p;

    $entry =~ /^.*\n((?s).*)/m;
    $p{ body } = $1 if $1;

    return \%p;
}


1;
