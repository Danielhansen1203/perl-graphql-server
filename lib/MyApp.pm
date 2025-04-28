package MyApp;
use Mojo::Base 'Mojolicious';

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

    # Simple GET route
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });

    # GraphQL endpoint
    $r->post('/graphql')->to('graphql#graphql');
}

1;
