package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Schema::Graphql;

sub startup {
    my $self = shift;

    # Fortæl serveren at den skal lytte på 0.0.0.0:3000
    $self->config(
        hypnotoad => {
            listen => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    # Routes
    my $r = $self->routes;

    $self->plugin('GraphQL', {
        schema => MyApp::Schema::Graphql->new->graphql_schema
    });

    $r->post('/graphql')->to('GraphQL#execute');

    # Simple GET route
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });

}

1;
