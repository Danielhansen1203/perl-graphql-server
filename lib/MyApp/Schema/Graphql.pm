package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub graphql_schema {
    my ($class, $snmp_model) = @_;

    my $sdl = <<'EOF';
type Query {
  hello: String
}
EOF

    return GraphQL::Schema->from_doc(
        $sdl,
        {
            Query => {
                hello => sub { return "world" },
            },
        }
    );
}
1;

1;
