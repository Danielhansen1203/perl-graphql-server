package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub schema {
    my ($snmp_model) = @_;

    my $doc = <<'GRAPHQL';
type Query {
  temperature(ip: String!): Float
  ports(ip: String!): [Port]
}

type Port {
  name: String
  status: String
}
GRAPHQL

    return GraphQL::Schema->from_doc($doc, {
      temperature => sub {
        my ($root, $args) = @_;
        return $snmp_model->get_temperature($args->{ip});
      },
      ports => sub {
        my ($root, $args) = @_;
        return $snmp_model->get_ports_in_use($args->{ip});
      },
    });
}

1;
