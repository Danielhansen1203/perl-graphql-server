package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

sub startup {
    my $self = shift;

    $self->config(hypnotoad => { listen => ['http://*:3000'] });

    my $snmp    = MyApp::Model::SNMP->new;
    my $schema  = MyApp::Schema::Graphql::build($snmp);

    my $r = $self->routes;
    $r->get('/')->to(cb => sub { shift->render(text => 'GraphQL app is running') });
    $r->post('/graphql')->to('graphql#execute');
    $r->get('/')->to('main#index');
}

1;