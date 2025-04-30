package MyApp;
use Mojo::Base 'Mojolicious';

use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

sub startup {
    my $self = shift;

    my $snmp = MyApp::Model::SNMP->new;

    $self->plugin('GraphQL' => {
        schema => MyApp::Schema::Graphql->graphql_schema($snmp),
    });

    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
}

1;
