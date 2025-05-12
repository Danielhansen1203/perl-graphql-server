package MyApp::Model::Homeassist;
use Mojo::Base 'MyApp::Model::Base';

# Service-specific attributes
has 'ha_url';
has 'ha_token';
has 'api_url';
has 'ua';

# Constructor: merge defaults with app config
sub new {
  my ($class, $app, %args) = @_;
  my $cfg = $app->config->{homeassistant} || {};
  return $class->SUPER::new(
    $app,
    ha_url   => $cfg->{url},
    ha_token => $cfg->{token},
    api_url  => $cfg->{api_url},
    ua => Mojo::UserAgent->new,
    %args,
  );
}

# Turn light on/off via Home Assistant
sub changeLightState {
  my ($self, $entity_id, $state) = @_;
  my $log = $self->logger;

  my $lightFunc = $state ? 'turn_on' : 'turn_off';
  $log->debug("[HA] Changing light: $lightFunc $entity_id");

  my $tx = $self->ua->post(
    $self->api_url . "/light/$lightFunc" => {
      Authorization => "Bearer " . $self->ha_token,
      'Content-Type' => 'application/json'
    } => json => { entity_id => $entity_id }
  );

  my $res = $tx->result;
  if ($res->is_success) {
    return "$lightFunc: $entity_id";
  }
  else {
    $log->error("[HA] Error $lightFunc: " . $res->code . " - " . $res->message);
    return "Error: " . $res->message;
  }
}

1;