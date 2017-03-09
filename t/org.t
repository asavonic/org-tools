use Org;

use Test::More tests => 8;

my $entry = Org::format_entry( todo_keyword => "TODO",
                                title => "Awesome title",
                                body => "Something very cool",
                                tags => ["T1", "T2"]);

like $entry, qr/TODO Awesome title \s* :T1:T2:\nSomething very cool/, basic1;

my $header_line = (split /\n/, $entry)[0];
is length $header_line, 80, header_line_max_length;

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
'TODO Awesome header                                                      :T1:T2:
Something.
More.
';

test_not_vise_versa
'TODO Awesome header  :T1:T2:
Something.
More.
';

test_vise_versa
'TODO Awesome header
Something.
More.
';

test_vise_versa
'Awesome header                                                           :T1:T2:
Something.
More.
';

test_vise_versa
'TODO Awesome header                                                      :T1:T2:
';

test_vise_versa
'Awesome header
';

