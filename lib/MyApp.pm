package MyApp;
use Mojo::Base 'Mojolicious';

use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

sub startup {
    my $self = shift;

 $self->config(
        hypnotoad => {
            listen  => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    my $snmp = MyApp::Model::SNMP->new;

    $self->plugin('GraphQL' => {
        schema => MyApp::Schema::Graphql->graphql_schema($snmp)
    });

    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
      $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });
}

1;
