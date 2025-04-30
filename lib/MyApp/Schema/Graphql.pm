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
