use Org;

use Test::More tests => 16;

my $entry = Org::format_entry( level => 2,
                               todo_keyword => "TODO",
                               title => "Awesome title",
                               body => "Something very cool",
                               tags => ["T1", "T2"] );

like $entry, qr/\*\* TODO Awesome title \s* :T1:T2:\nSomething very cool/, basic1;

my $header_line = (split /\n/, $entry)[0];
is length $header_line, 80, header_line_max_length;

is Org::format_entry( body => "Something very cool." ),
   "Something very cool.", bare_body_entry;

is Org::parse_entry("** Header\nBody")->{ level }, 2, parse_level;

sub test_vise_versa {
    my $orig = shift;
    my %entry = %{Org::parse_entry $orig};
    my $formatted = Org::format_entry %entry;

    is $formatted, $orig, test_vise_versa;
}

sub test_not_vise_versa {
    my $orig = shift;
    my %entry = %{Org::parse_entry $orig};
    my $formatted = Org::format_entry %entry;

    not is $formatted, $orig, test_not_vise_versa;
}


test_vise_versa
'* TODO Awesome header                                                      :T1:T2:
Something.
More.
';

test_not_vise_versa
'* TODO Awesome header  :T1:T2:
Something.
More.
';

test_vise_versa
'* TODO Awesome header
Something.
More.
';

test_vise_versa
'* Awesome header                                                           :T1:T2:
Something.
More.
';

test_vise_versa
'* TODO Awesome header                                                      :T1:T2:
';

test_vise_versa
'* Awesome header
';

test_vise_versa
'Something.
More.
';

my @entries = @{ Org::parse_file("* Title 1\nContent 1\nContent 1\n" .
                                 "* Title 2\nContent 2\nContent 2\n") };
is scalar @entries, 2, file_parse_count;
is $entries[0]->{ title }, "Title 1", file_parse_1_title;
is $entries[0]->{ body }, "Content 1\nContent 1", file_parse_1_body;
is $entries[1]->{ title }, "Title 2", file_parse_2_title;
is $entries[1]->{ body }, "Content 2\nContent 2", file_parse_2_body;
