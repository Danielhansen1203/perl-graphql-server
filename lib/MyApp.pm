package MyApp;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    my $r = $self->routes;

    # ROUTES

    # Simple default GET route (viser serveren kører)
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });

    # GraphQL endpoint POST /graphql
    $r->post('/graphql')->to('graphql#graphql');
}

1;
