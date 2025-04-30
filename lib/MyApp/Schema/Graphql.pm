package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub graphql_schema {
    my ($class, $snmp_model) = @_;

    my $sdl = <<'EOF';
type Query {
  interfaceStatus(ip: String!, oid: String!): String
}
EOF

    return GraphQL::Schema->from_doc(
        $sdl,
        {
            Query => {
                interfaceStatus => sub {
                    my ($root, $args) = @_;
                    return $snmp_model->get_interface_status($args->{ip}, $args->{oid});
                },
            },
        }
    );
}

1;
