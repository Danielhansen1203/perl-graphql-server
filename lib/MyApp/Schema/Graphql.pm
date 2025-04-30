package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub graphql_schema {
    my ($class, $snmp_model) = @_;

    return GraphQL::Schema->from_doc(
        <<'EOF',
schema {
  query: Query
}

type Query {
  sysdescr(ip: String!): String
}
EOF
        ,
        {
            sysdescr => sub {
                my ($root, $args) = @_;
                return $snmp_model->get_sysdescr($args->{ip});
            },
        }
    );
}

1;
