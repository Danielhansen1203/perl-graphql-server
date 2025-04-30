package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;
use GraphQL::Plugin::Convert qw(to_graphql);

sub graphql_schema {
    my ($class, $snmp_model) = @_;

    return GraphQL::Schema->from_doc(
        <<'GRAPHQL',
type Query {
  sysdescr(ip: String!): String
}
GRAPHQL
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
