use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

sub startup {
    my $self = shift;

    $self->config(hypnotoad => { listen => ['http://*:3000'] });

    my $snmp    = MyApp::Model::SNMP->new;
    my $schema  = MyApp::Schema::Graphql::build($snmp);

    $self->plugin(GraphQL => $schema);

    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
    $r->get('/')->to('main#index');
}

1;