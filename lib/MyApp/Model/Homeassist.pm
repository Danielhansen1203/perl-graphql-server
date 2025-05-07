package MyApp::Schema::Homeassist;
use strict;
use warnings;
use Mojo::UserAgent;

# Opsæt Home Assistant-adgang
my $ha_url = 'http://192.168.0.39:8123';  # eller din HA-IP, fx http://192.168.1.50:8123
my $ha_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiYmQzZTg0MTQ1OWI0ZjMxYTJmNTBmNWM3NDEwNjIwYiIsImlhdCI6MTc0NjY0OTgwMSwiZXhwIjoyMDYyMDA5ODAxfQ.VAG2t3uNIQDi4KRWBYJ-auyngWIAyt1EFwbfdvIBJIE';       # Udskift med din token
my $ua = Mojo::UserAgent->new;

sub changeLightState {
            my ($class, $entity_id, $state) = @_;
            my $lightFunc = ""
            if ($state = true) {
                $lightFunc = "turn_on";
            } else {
                $lightFunc = "turn_off"
            }
            my $tx = $ua->post("$ha_url/api/services/light/$lightFunc" => {
                Authorization => "Bearer $ha_token",
                'Content-Type' => 'application/json'
            } => json => {
                entity_id => $entity_id
            });
            my $res = $tx->result;
            return $res->is_success
                ? "$lightFunc: $entity_id"
                : "Fejl: " . $res->message;
        }

sub returnMsg {
    my ($self, $tx, $onState) = @_;
    my $res = $tx->result;
            return $res->is_success
                ? "Slukket: $entity_id"
                : "Fejl: " . $res->message;
}


1;
