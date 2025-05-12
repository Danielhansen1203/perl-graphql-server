package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;
use MyApp::Model::Homeassist;
use MyApp::Model::SNMP;

# Schema bygges kun én gang (SDL)
sub schema {
    my $sdl = <<'GRAPHQL';
type Query {
  hejAbkat: String
  interfaceStatus(ip: String!, oid: String!): String
}

type Mutation {
  changeLightState(entity_id: String!, state: Boolean!): String
}
GRAPHQL

    return GraphQL::Schema->from_doc($sdl);
}

# Root value bygges pr. request, med adgang til $c
sub build_root {
    my ($c) = @_;

    return {
        hejAbkat => with_context(sub {
            my ($args, $c) = @_;
            return "Hvis dette virker er det insane!";
        }, $c),

        interfaceStatus => with_context(sub {
            my ($args, $c) = @_;
            return $c->snmp_model->get_interface_status($args->{ip}, $args->{oid});
        }, $c),

        changeLightState => with_context(sub {
            my ($args, $c) = @_;
            return $c->homeassist->changeLightState($args->{entity_id}, $args->{state});
        }, $c),

    };
}


sub with_context {
    my ($code, $c) = @_;
    return sub {
        my ($args) = @_;
        return $code->($args, $c);
    };
}


1;
