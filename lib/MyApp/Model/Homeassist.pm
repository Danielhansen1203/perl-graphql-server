package MyApp::Model::Homeassist;
use strict;
use warnings;
use Mojo::UserAgent;
use base 'MyApp::Model::Base';

# Home Assistant config
my $ha_url   = 'http://192.168.0.39:8123';
my $ha_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiYmQzZTg0MTQ1OWI0ZjMxYTJmNTBmNWM3NDEwNjIwYiIsImlhdCI6MTc0NjY0OTgwMSwiZXhwIjoyMDYyMDA5ODAxfQ.VAG2t3uNIQDi4KRWBYJ-auyngWIAyt1EFwbfdvIBJIE';  # ← indsæt din token
my $ua       = Mojo::UserAgent->new;
my $api_url  = "$ha_url/api/services";

# Tænd/sluk lys via Home Assistant
sub changeLightState {
    my ($self, $entity_id, $state) = @_;
    my $log = $self->{logger};

    my $lightFunc = $state ? 'turn_on' : 'turn_off';
    $log->debug("[HA] Skifter lys: $lightFunc $entity_id");

    my $tx = $ua->post("$api_url/light/$lightFunc" => {
        Authorization => "Bearer $ha_token",
        'Content-Type' => 'application/json'
    } => json => {
        entity_id => $entity_id
    });

    my $res = $tx->result;

    if ($res->is_success) {
        return "$lightFunc: $entity_id";
    } else {
        $log->error("[HA] Fejl $lightFunc: " . $res->code . " - " . $res->message);
        return "Fejl: " . $res->message;
    }
}

1;
