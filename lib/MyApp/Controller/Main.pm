package MyApp::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $c = shift;
    $c->render(template => 'main/index');
}

1;
