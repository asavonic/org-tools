use Org;

use Test::More tests => 2;

# Org::format_entry tests

my $entry = Org::format_entry( todo_keyword => "TODO",
                                title => "Awesome title",
                                body => "Something very cool",
                                tags => ["T1", "T2"]);

like $entry, qr/TODO Awesome title \s* :T1:T2:\nSomething very cool/, basic;

my $header_line = (split /\n/, $entry)[0];
is length $header_line, 80, header_line_max_length;


