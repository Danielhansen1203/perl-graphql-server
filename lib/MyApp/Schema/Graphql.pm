package MyApp::Schema::Graphql;
use strict;
use warnings;

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
  turnOnLight(entity_id: String!): String
  turnOffLight(entity_id: String!): String
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

        turnOnLight => sub {
            my ($args) = @_;
            my $entity_id = $args->{entity_id};

            my $tx = $ua->post("$ha_url/api/services/light/turn_on" => {
                Authorization => "Bearer $ha_token",
                'Content-Type' => 'application/json'
            } => json => {
                entity_id => $entity_id
            });
            my $res = $tx->result;
            return $res->is_success
                ? "Tændt: $entity_id"
                : "Fejl: " . $res->message;
        },
        turnOffLight => sub {
            my ($args) = @_;
            my $entity_id = $args->{entity_id};

            my $tx = $ua->post("$ha_url/api/services/light/turn_off" => {
                Authorization => "Bearer $ha_token",
                'Content-Type' => 'application/json'
            } => json => {
                entity_id => $entity_id
            });
            my $res = $tx->result;
            return $res->is_success
                ? "Slukket: $entity_id"
                : "Fejl: " . $res->message;
        },

    };

    return {
        schema     => $schema,
        root_value => $root_value,
    };
}

1;
