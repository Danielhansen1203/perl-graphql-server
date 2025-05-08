package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Model::SNMP;
use MyApp::Model::Homeassist;
use MyApp::Schema::Graphql;

sub startup {

    my $self = shift;

    $self->helper(homeassist => sub {
        my $c = shift;
        MyApp::Model::Homeassist->new(logger => $c->app->log);
    });

    $self->helper(snmp_model => sub {
        my $c = shift;
        MyApp::Model::SNMP->new(logger => $c->app->log);
    });



    $self->config(hypnotoad => { listen => ['http://*:3000'] });    

    my $r = $self->routes;
    $r->get('/')->to('main#index');
    $r->post('/graphql')->to('graphql#execute');
    
}

1;