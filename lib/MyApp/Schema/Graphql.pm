package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub build {
    warn "Step 1";
    my ($snmp_model) = @_;

    my $sdl = <<'GRAPHQL';
type Query {
  GetSNMPInfo(ip: String!, oid: String!): String
  hejAbkat: String
}
GRAPHQL

    my $root_value = {
        GetSNMPInfo => sub {
            my ($args) = @_;
            return $snmp_model->get_snmp_info($args->{ip}, $args->{oid});
        },
        hejAbkat => sub {
            return "Hvis dette virker er det insane!";
        },
    };

    return {
        schema      => GraphQL::Schema->from_doc($sdl),
        root_value  => $root_value,
    };
}

1;
