package MyApp::Schema::Graphql;
use strict;
use warnings;
use MyApp::Model::Homeassist;
use GraphQL::Schema;
use Mojo::UserAgent;

# Opsæt Home Assistant-adgang
my $ha_url = 'http://192.168.0.39:8123';  # eller din HA-IP, fx http://192.168.1.50:8123
my $ha_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiYmQzZTg0MTQ1OWI0ZjMxYTJmNTBmNWM3NDEwNjIwYiIsImlhdCI6MTc0NjY0OTgwMSwiZXhwIjoyMDYyMDA5ODAxfQ.VAG2t3uNIQDi4KRWBYJ-auyngWIAyt1EFwbfdvIBJIE';       # Udskift med din token
my $ua = Mojo::UserAgent->new;

sub build {
    my ($snmp_model) = @_;

    my $sdl = <<'GRAPHQL';
type Query {
  hejAbkat: String
  interfaceStatus(ip: String!, oid: String!): String
}

type Mutation {
  changeLightState(entity_id: String!, state: Boolean!): String
}
GRAPHQL

    my $schema = GraphQL::Schema->from_doc($sdl);

    my $root_value = {
        hejAbkat => sub {
            return "Hvis dette virker er det insane!";
        },

        interfaceStatus => sub {
            my ($args) = @_;
            return $snmp_model->get_interface_status($args->{ip}, $args->{oid});
        },

        changeLightState => sub {
            my ($args) = @_;
            return MyApp::Model::Homeassist->changeLightState($args->{entity_id}, $args->{state});
        },

    };

    return {
        schema     => $schema,
        root_value => $root_value,
    };
}

1;
