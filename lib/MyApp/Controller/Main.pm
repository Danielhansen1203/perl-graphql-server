package MyApp::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use FindBin;
use File::Spec;

# GET /
sub index {
  my $c    = shift;
  $c->render(template => 'main/index');
}

1;